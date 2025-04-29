shader_type spatial;
render_mode unshaded;

uniform sampler2D image : source_color, repeat_disable;
uniform float exposure: hint_range(0.5, 5.0, 0.1) = 1.0;
uniform int curve: hint_enum("Blender AgX", "Fitted Timothy Lottes", "allenwp-piecewise");
uniform float white_val: hint_range(2.0, 40.0, 0.1) = 16.2917402385381;
uniform float max_out: hint_range(1.0, 20.0, 0.1) = 1.0;
uniform float lottes_contrast: hint_range(0.5, 3.0, 0.01) = 1.36989969378897;
uniform float lottes_shoulder: hint_range(0.6, 1.0, 0.01) = 0.903916850555009;
uniform float contrast: hint_range(1.0, 2.0, 0.01) = 1.25652780401491;
uniform float shoulder: hint_range(0.5, 1.0, 0.01) = 0.867980409496234; // Shoulder of 1.0 is just plain and simple Reinhard
uniform bool new_matrices = true;

const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
		vec3(0.62751148770907403411, 0.069107555861366290094, 0.016396571916060692158),
		vec3(0.32927727964735428428, 0.91950325371517433606, 0.088024234821922748922),
		vec3(0.04330296975639152724, 0.011359406931309376229, 0.89551332165316518758));
		
const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
		vec3(1.6602062978811019111, -0.12455265278490989962, -0.018154995139836493422),
		vec3(-0.58755383980194848639, 1.1329456581856140455, -0.10060465175595819539),
		vec3(-0.07282705725221054784, -0.008348386143453457498, 1.1188320152896576747));


struct Chromaticities {
    vec2 red;
    vec2 green;
    vec2 blue;
    vec2 white;
};

// Constructs a scaling matrix with a given origin
mat4 scalingMatrix(vec3 scaleFactors, vec3 origin) {
    vec3 offset = origin - origin * scaleFactors;

    return mat4(
        vec4(scaleFactors.x, 0.0,           0.0,           0.0),
        vec4(0.0,           scaleFactors.y, 0.0,           0.0),
        vec4(0.0,           0.0,           scaleFactors.z, 0.0),
        vec4(offset.x,      offset.y,      offset.z,      1.0)
    );
}

// Apply it to a point
vec2 scale(vec2 pos, vec2 scaleFactors, vec2 origin) {
	vec3 pos3 = vec3(pos, 0);
	vec3 scaleFactors3 = vec3(scaleFactors, 1);
	vec3 origin3 = vec3(origin, 0);
    mat4 m = scalingMatrix(scaleFactors3, origin3);
    return (m * vec4(pos3, 1.0)).xy;
}

// Rotates a 2D point 'pos' around 'origin' by 'angle' (in degrees)
vec2 rotate(vec2 pos, float angle, vec2 origin) {
	angle = angle * 3.1415926535897932384626433 / 180.0; // convert from degrees
    float c = cos(angle);
    float s = sin(angle);

    // Compute offset terms based on origin
    float xoff = origin.x - origin.x * c + origin.y * s;
    float yoff = origin.y - origin.x * s - origin.y * c;

    // Apply rotation matrix with translation offset
    return vec2(
        pos.x * c - pos.y * s + xoff,
        pos.x * s + pos.y * c + yoff
    );
}

// Computes the RGB to XYZ transformation matrix
mat3 RGBtoXYZ(Chromaticities N) {
    // Compute the XYZ coordinates of the primaries
    vec3 X = vec3(N.red.x / N.red.y, N.green.x / N.green.y, N.blue.x / N.blue.y);
    vec3 Y = vec3(1.0, 1.0, 1.0);
    vec3 Z = vec3(
        (1.0 - N.red.x - N.red.y) / N.red.y,
        (1.0 - N.green.x - N.green.y) / N.green.y,
        (1.0 - N.blue.x - N.blue.y) / N.blue.y
    );

    // Assemble the matrix from the primaries
   	mat3 M = mat3(X, Y, Z);

    // Compute the XYZ coordinates of the white point
    vec3 white = vec3(
        N.white.x / N.white.y,
        1.0,
        (1.0 - N.white.x - N.white.y) / N.white.y
    );

    // Compute the scaling factors
    vec3 S = inverse(M) * white;

    // Scale columns of M
    M[0] *= S.x;
    M[1] *= S.y;
    M[2] *= S.z;

    return M;
}

mat3 XYZtoRGB(Chromaticities N) {
	return inverse(RGBtoXYZ(N));
}

mat3 RGBtoRGB(Chromaticities N,Chromaticities M){
  mat3 In2XYZ = RGBtoXYZ(N);
  mat3 XYZ2Out = XYZtoRGB(M);

  mat3 rgbtorgb = In2XYZ * XYZ2Out;

  return rgbtorgb;
}





vec3 exponential(vec3 x_in, float power) {
	return x_in / pow(1.0 + pow(x_in, vec3(power)), vec3(1.0 / power));
}

vec3 exponential_curve(vec3 x_in, vec3 scale_input, float slope, float power, float transition_x, float transition_y) {
	vec3 result = (scale_input * exponential(((slope * (x_in - transition_x)) / scale_input), power)) + transition_y;
	// Even when x_in is non-negative, rounding error can cause the result to be -0.
	// This clipping deals with cases of negative input and rounding error.
	return max(result, 0.0);
}

float scale_function(float transition_x, float transition_y, float power, float slope) {
	float term_a = pow(slope * (1.0 - transition_x), -1.0 * power);
	float term_b = pow((slope * (1.0 - transition_x)) / (1.0 - transition_y), power) - 1.0;
	return pow(term_a * term_b, -1.0 / power);
}

vec3 calculate_sigmoid(vec3 x_in, float midgrey, float normalized_log2_minimum, float normalized_log2_maximum) {
	const float slope = 2.4;
	const float power = 1.5;

	// pivot_x is 0.18 (middle gray) in original linear values
	float pivot_x = abs(normalized_log2_minimum) / (normalized_log2_maximum - normalized_log2_minimum);
	float pivot_y = pow(midgrey, (1.0 / 2.4));

	vec3 bottom_scale = vec3(-1.0 * scale_function(1.0 - pivot_x, 1.0 - pivot_y, power, slope));
	vec3 top_scale = vec3(scale_function(pivot_x, pivot_y, power, slope));
	vec3 scaleValue = mix(top_scale, bottom_scale, lessThan(x_in, vec3(pivot_x)));
	return exponential_curve(x_in, scaleValue, slope, power, pivot_x, pivot_y);
}

// log_encoding_Log2 from colour/models/rgb/transfer_functions/log.py of colour science package
vec3 log_encoding_Log2(vec3 lin, float middle_grey, float min_exposure, float max_exposure) {
	lin = lin / middle_grey;
	lin = max(lin, 1e-10); // prevent undefined behaviour of log2(0.0)
	vec3 lg2 = log2(lin);
	vec3 log_norm = (lg2 - min_exposure) / (max_exposure - min_exposure);
	return log_norm; // Might be negative, but negatives are clipped later.
}





// This is a simplified glsl implementation of EaryChow's AgX that is used by Blender.
// Input: unbounded linear Rec. 709
// Output: unbounded linear Rec.709 (Most any value you care about will be within [0.0, 1.0], thus safe to clip.)
// This code is based off of the script that generates the AgX_Base_sRGB.cube LUT that Blender uses.
// Source: https://github.com/EaryChow/AgX_LUT_Gen/blob/main/AgXBasesRGB.py
// Changes: Negative clipping in input color space without "guard rails" and no chroma-angle mixing.
// Added parameter normalized_log2_maximum to allow white value to be changed.
// Default normalized_log2_maximum is 6.5.
// If you have a white value in linear space, you can transform it to a normalized_log2_maximum prameter like this:
// white = max(1.172, white); // Sigmoid function breaks down with a lower max than this.
// float normalized_log2_maximum = log2(white / 0.18); // 0.18 is "midgrey".
vec3 tonemap_agx(vec3 color, float normalized_log2_maximum) {
	color = exposure * color;
	const float midIn = 0.18;
	const float midOut = 0.18;
    float maxVal = max(max_out, 1.0);
    float white = max(white_val, maxVal);
			
	const mat3 agx_inset_matrix = mat3(
			vec3(0.856627153315983, 0.137318972929847, 0.11189821299995),
			vec3(0.0951212405381588, 0.761241990602591, 0.0767994186031903),
			vec3(0.0482516061458583, 0.101439036467562, 0.811302368396859));
	const mat3 agx_inset_matrix_new = mat3(
			vec3(0.856627156288779, 0.137318972283552, 0.11189820804518),
			vec3(0.0951212454025349, 0.761241987009081, 0.0767994145625176),
			vec3(0.0482515983086858, 0.101439040707367, 0.811302377392303));
			
	const mat3 agx_outset_matrix = mat3(
			vec3(0.89979695591161, 0.11142098895748, 0.11142098895748),
			vec3(0.0871996192028351, 0.875575586156966, 0.0871996192028349),
			vec3(0.0130034248855548, 0.0130034248855548, 0.801379391839685));
	const mat3 agx_outset_matrix_new = mat3(
			vec3(0.899796963837832, 0.11142098366896, 0.11142098366896),
			vec3(0.0871996171023204, 0.875575597271192, 0.0871996171023203),
			vec3(0.0130034190598471, 0.0130034190598472, 0.801379399228719));

	const float midgrey = 0.18;
	const float normalized_log2_minimum = -10.0;

	// Large negative values in one channel and large positive values in other
	// channels can result in a colour that appears darker and more saturated than
	// desired after passing it through the inset matrix. For this reason, it is
	// best to prevent negative input values.
	// This is done before the Rec. 2020 transform to allow the Rec. 2020
	// transform to be combined with the AgX inset matrix. This results in a loss
	// of color information that could be correctly interpreted within the
	// Rec. 2020 color space as positive RGB values, but is often not worth
	// the performance cost of an additional matrix multiplication.
	color = max(color, 0);

	// Apply inset matrix.
	color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;
	if (new_matrices) {
		color = agx_inset_matrix_new * color;
	}
	else {
		color = agx_inset_matrix * color;
	}
	
	
	// Apply Log2 curve to prepare for sigmoid.
	vec3 blender = log_encoding_Log2(color, midgrey, normalized_log2_minimum, normalized_log2_maximum);
	// Apply sigmoid function.
	blender = calculate_sigmoid(blender, midgrey, normalized_log2_minimum, normalized_log2_maximum);
	// Convert back to linear before applying outset matrix.
	blender = pow(blender, vec3(2.4));

	// Terms of Timothy Lottes' tonemapping curve equation:
	// c and b are calculated based on a and d with AgX mid and max parameters
	// using the Mathematica notebook in the source AgX-GLSL-Shaders repository.
	float a = lottes_contrast;
	float d = lottes_shoulder;
	
	float b = (maxVal * pow(midIn, a) - midOut * pow(white, a)) / (maxVal * midOut * (pow(pow(midIn, a), d) - pow(pow(white, a), d)));
	float c = (pow(pow(midIn, a), d) * midOut * pow(white, a) - maxVal * pow(midIn, a) * pow(pow(white, a), d)) / (maxVal * midOut * (pow(pow(midIn, a), d) - pow(pow(white, a), d)));
	vec3 z = pow(color, vec3(a));
	vec3 timLottes = z / (pow(z, vec3(d)) * b + c);

	if (curve == 0) {
		color = blender;
	} else if (curve == 1) {
		color = timLottes;
	} else if (curve == 2) {
		// CPU side calculations:
        float toe_a = -1.0 * ((pow(midIn, contrast) * (midOut - 1.0)) / midOut); // Can be simplified when midIn == midOut == 0.18: (41.0 / 9.0) * pow(0.18, contrast)
        // Slope formula is simply the derivative of the toe function with an input of midOut
        float slope_a = pow(midIn, contrast) + toe_a;
        float slope = (contrast * pow(midIn, contrast - 1.0) * toe_a) / (slope_a * slope_a);

        float c = pow(midIn - white, 2.0) / (maxVal * shoulder - midOut * shoulder + (-1.0 + shoulder) * slope * (midIn - white));

        float shoulderMaxVal = maxVal - midOut;

		vec3 s = color;
        // GPU side calculations:
        // Shoulder
        s -= midIn;
        // Original modified Reinhard function in [0,1]: x = (x * (D + x / (C)) / (D + x)); // Solve for C such that white outputs 1.0
        s = slope * s * (shoulder + s / (c * slope)) / (shoulder + (s * slope) / shoulderMaxVal);
        s += midOut;
		
        // Toe
        vec3 t = pow(color, vec3(contrast));
        t = t / (t + vec3(toe_a));
		
		color = mix(s, t, lessThan(color, vec3(0.18)));
	}

	// Apply outset to make the result more chroma-laden and then go back to linear sRGB.
	
	if (new_matrices) {
		color = inverse(agx_outset_matrix_new) * color;
	}
	else {
		color = inverse(agx_outset_matrix) * color;
	}
	color = LINEAR_REC2020_TO_LINEAR_SRGB * color;

	// Blender's lusRGB.compensate_low_side is too complex for this shader, so
	// simply return the color, even if it has negative components. These negative
	// components may be useful for subsequent color adjustments.
	return color;
	return color / maxVal;
}

void fragment() {
	vec3 color = texture(image, UV).rgb;
	
	color = tonemap_agx(color, 6.5);
	
	ALBEDO = color;
}
