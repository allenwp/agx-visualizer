shader_type spatial;
render_mode unshaded;

uniform sampler2D image : source_color, repeat_disable;
uniform float exposure: hint_range(0.5, 5.0, 0.1) = 1.0;
uniform int curve: hint_enum("Blender AgX", "Fitted Timothy Lottes", "allenwp-piecewise", "allenwp-piecewise-power", "allenwp-piecewise-power-alt");
uniform float white_in: hint_range(2.0, 40.0, 0.1) = 16.2917402385381;
uniform float maxVal_in: hint_range(1.0, 20.0, 0.1) = 1.0;
uniform float lottes_contrast: hint_range(0.5, 3.0, 0.01) = 1.36989969378897;
uniform float lottes_shoulder: hint_range(0.6, 1.0, 0.01) = 0.903916850555009;
uniform float contrast: hint_range(1.0, 2.0, 0.01) = 1.25652780401491;
uniform float shoulder: hint_range(0.5, 1.0, 0.01) = 0.867980409496234; // Shoulder of 1.0 is just plain and simple Reinhard

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
    float maxVal = max(maxVal_in, 1.0);
    float white = max(white_in, maxVal);
	
	// Combined linear sRGB to linear Rec 2020 and Blender AgX inset matrices:
	const mat3 srgb_to_rec2020_agx_inset_matrix = mat3(
			vec3(0.54490813676363087053, 0.14044005884001287035, 0.088827411851915368603),
			vec3(0.37377945959812267119, 0.75410959864013760045, 0.17887712465043811023),
			vec3(0.081384976686407536266, 0.10543358536857773485, 0.73224999956948382528));

	// Combined inverse AgX outset matrix and linear Rec 2020 to linear sRGB matrices.
	const mat3 agx_outset_rec2020_to_srgb_matrix = mat3(
			vec3(1.9645509602733325934, -0.29932243390911083839, -0.16436833806080403409),
			vec3(-0.85585845117807513559, 1.3264510741502356555, -0.23822464068860595117),
			vec3(-0.10886710826831608324, -0.027084020983874825605, 1.402665347143271889));

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
	color = srgb_to_rec2020_agx_inset_matrix * color;

	
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
	else if (curve == 3) {
        float toe_a = -1.0 * ((pow(midIn, contrast) * (midOut - 1.0)) / midOut); // Can be simplified when midIn == midOut == 0.18: (41.0 / 9.0) * pow(0.18, contrast)
        // Slope formula is simply the derivative of the toe function with an input of midOut
        float slope_a = pow(midIn, contrast) + toe_a;
        float slope = (contrast * pow(midIn, contrast - 1.0) * toe_a) / (slope_a * slope_a);

        float c = log((maxVal + midOut * (-1. + shoulder) - maxVal * shoulder + shoulder * slope * (-midIn + white)) / slope) / log(-midIn + white);;

        float shoulderMaxVal = maxVal - midOut;
		float w = white - midIn;
        w = w * w;
        w = w / shoulderMaxVal;
        w = w * slope;

		vec3 s = color;
        // GPU side calculations:
        // Shoulder
        s -= midIn;
        s = slope * s * (shoulder + s / w) / (shoulder + (pow(s, vec3(c)) * slope) / shoulderMaxVal);
        s += midOut;
		
        // Toe
        vec3 t = pow(color, vec3(contrast));
        t = t / (t + vec3(toe_a));
		
		color = mix(s, t, lessThan(color, vec3(0.18)));
	}
	else if (curve == 4) {
        float toe_a = -1.0 * ((pow(midIn, contrast) * (midOut - 1.0)) / midOut); // Can be simplified when midIn == midOut == 0.18: (41.0 / 9.0) * pow(0.18, contrast)
        // Slope formula is simply the derivative of the toe function with an input of midOut
        float slope_a = pow(midIn, contrast) + toe_a;
        float slope = (contrast * pow(midIn, contrast - 1.0) * toe_a) / (slope_a * slope_a);

        float c = (-1.0 * maxVal + midOut + slope * pow(-1.0 * midIn + white, shoulder)) / (-1.0 * maxVal + midOut + slope * (-1.0 * midIn + white));

        float shoulderMaxVal = maxVal - midOut;
		float w = white - midIn;
        w = w * w;
        w = w / shoulderMaxVal;
        w = w * slope;

		vec3 s = color;
        // GPU side calculations:
        // Shoulder
        s -= midIn;
        s = slope * s * (c + s / w) / (c + (pow(s, vec3(shoulder)) * slope) / shoulderMaxVal);
        s += midOut;
		
        // Toe
        vec3 t = pow(color, vec3(contrast));
        t = t / (t + vec3(toe_a));
		
		color = mix(s, t, lessThan(color, vec3(0.18)));
	}

	// Apply outset to make the result more chroma-laden and then go back to linear sRGB.
	color = agx_outset_rec2020_to_srgb_matrix * color;

	// Blender's lusRGB.compensate_low_side is too complex for this shader, so
	// simply return the color, even if it has negative components. These negative
	// components may be useful for subsequent color adjustments.
	return color / maxVal;
}

void fragment() {
	vec3 color = texture(image, UV).rgb;
	
	color = tonemap_agx(color, 6.5);
	
	ALBEDO = color;
}
