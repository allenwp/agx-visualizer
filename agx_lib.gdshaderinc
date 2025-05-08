/* ##########################################################################
    Custom Structs
    ---------------------------
*/

struct Chromaticities {
    vec2 red;
    vec2 green;
    vec2 blue;
    vec2 white;
};

/* ##########################################################################
    Color Conversion Matrices
    ---------------------------
*/

// Gamut conversion Matrices
//AP0, AP1 and P3D60 was changed to D65
#define identity_mtx make_float3x3(make_float3(1.0f, 0.0f, 0.0f), make_float3(0.0f, 1.0f, 0.0f), make_float3(0.0f, 0.0f, 1.0f))
#define matrix_ap0_to_xyz make_float3x3(make_float3(0.93863095f, -0.00574192f, 0.0175669f), make_float3(0.33809359f,0.7272139f, -0.0653075f), make_float3(0.00072312f, 0.00081844, 1.08751619f))
#define matrix_ap1_to_xyz make_float3x3(make_float3(0.65241872f, 0.12717993f, 0.17085728f), make_float3(0.26806406f, 0.67246448f, 0.05947146f), make_float3(-0.00546993f,0.0051828f, 1.08934488f))
#define matrix_p3d65_to_xyz make_float3x3(make_float3(0.486571133137f, 0.265667706728f, 0.198217317462f), make_float3(0.228974640369f, 0.691738605499f, 0.079286918044f), make_float3(-0.000000000000f, 0.045113388449, 1.043944478035f))
#define matrix_p3d60_to_xyz make_float3x3(make_float3(0.504949748516f, 0.264681518078f, 0.183015048504f), make_float3(0.237623393536f, 0.689170777798f, 0.073206014931f), make_float3(-0.000000000000f, 0.044945921749f, 0.963879227638f))
#define matrix_p3dci_to_xyz make_float3x3(make_float3(0.445170015097f, 0.277134418488f, 0.172282665968f), make_float3(0.209491759539f, 0.721595287323f, 0.068913064897f), make_float3(-0.000000000000f, 0.047060567886f, 0.907355427742f))
#define matrix_rec2020_to_xyz make_float3x3(make_float3(0.636958122253f, 0.144616916776f, 0.168880969286f), make_float3(0.262700229883f, 0.677998125553f, 0.059301715344f), make_float3(0.000000000000f, 0.028072696179, 1.060985088348f))
#define matrix_rec709_to_xyz make_float3x3(make_float3(0.412390917540f, 0.357584357262f, 0.180480793118f), make_float3(0.212639078498f, 0.715168714523f, 0.072192311287f), make_float3(0.019330825657f, 0.119194783270f, 0.950532138348f))
#define matrix_arriwg_to_xyz make_float3x3(make_float3(0.638007640839f, 0.214703813195f, 0.097744457424f), make_float3(0.291953772306f, 0.823840856552f, -0.115794822574f), make_float3(0.002798279049f, -0.067034222186, 1.153293848038f))
#define matrix_redwg_to_xyz make_float3x3(make_float3(0.735275208950f, 0.068609409034f, 0.146571278572f), make_float3(0.286694079638f, 0.842979073524f, -0.129673242569f), make_float3(-0.079680845141f, -0.347343206406, 1.516081929207f))
#define matrix_sonysgamut3 make_float3x3(make_float3(0.599083900452f, 0.248925492167f, 0.102446496487f), make_float3(0.215075820684f, 0.885068416595f, -0.100144319236f), make_float3(-0.032065849751f, -0.027658388019, 1.148782014847f))
#define matrix_egamut_to_xyz make_float3x3(make_float3(0.705396831036f, 0.164041340351f, 0.081017754972f), make_float3(0.280130714178f, 0.820206701756f, -0.100337378681f), make_float3(-0.103781513870f, -0.072907261550, 1.265746593475f))
#define matrix_davinciwg_to_xyz make_float3x3(make_float3(0.700622320175f, 0.148774802685f, 0.101058728993f), make_float3(0.274118483067f, 0.873631775379f, -0.147750422359f), make_float3(-0.098962903023f, -0.137895315886, 1.325916051865f))
#define matrix_blackmagicwg_to_xyz make_float3x3(make_float3(0.606538414955f, 0.220412746072f, 0.123504832387f), make_float3(0.267992943525f, 0.832748472691f, -0.100741356611f), make_float3(-0.029442556202f, -0.086612440646, 1.205112814903f))
#define matrix_canoncinema_to_xyz make_float3x3(make_float3(0.71604965f, 0.12968348f, 0.1047228f),make_float3(0.26126136f, 0.86964215f, -0.1309035f),make_float3(-0.00967635f, -0.23648164f, 1.33521573f))
#define matrix_arriwg4_to_xyz make_float3x3(make_float3(0.704858320407232064f,  0.129760295170463003f, 0.115837311473976537f),make_float3(0.254524176404027025f, 0.781477732712002049f, 0.036001909116029039f),make_float3(0.0f, 0.0f, 1.089057750759878429f))

// Color Spaces Coordinates
//AP0, AP1 and P3D60 was changed to D65
const Chromaticities AP0 =
Chromaticities(vec2(0.734771f, 0.264663f), vec2(-0.00795f, 1.006817f), vec2(0.016895f, -0.062809f), vec2(0.3127f, 0.3129f));
//const Chromaticities AP0 =
//{ {0.7347f, 0.2653f}, {0.0f, 1.0f}, {0.0001f, -0.077f}, {0.32168f, 0.33767f} };
const Chromaticities AP1 =
Chromaticities(vec2(0.713016f, 0.292962f), vec2(0.158021f, 0.835539f), vec2(0.129469f, 0.045065f), vec2(0.3127f, 0.329f) );
//const Chromaticities AP1 =
//Chromaticities(vec2(0.713f, 0.293f), vec2(0.165f, 0.83f), vec2(0.128f, 0.044f), vec2(0.32168f, 0.33767f) );
const Chromaticities REC709_PRI =
Chromaticities(vec2(0.64f, 0.33f), vec2(0.3f, 0.6f), vec2(0.15f, 0.06f), vec2(0.3127f, 0.329f) );
const Chromaticities REC709_PRI_2012 =
Chromaticities(vec2(0.6366613f, 0.33388708f), vec2(0.33235734f, 0.57712478f), vec2( 0.13868026f, 0.1068737f), vec2(0.3127f, 0.329f) );
const Chromaticities P3D60_PRI =
Chromaticities(vec2(0.67912f, 0.32026f), vec2(0.25856f, 0.69172f), vec2(0.14946f, 0.05973f), vec2(0.3127, 0.329f) );
const Chromaticities P3D65_PRI =
Chromaticities(vec2(0.68f, 0.32f), vec2(0.265f, 0.69f), vec2(0.15f, 0.06f), vec2(0.3127f, 0.329f) );
const Chromaticities P3DCI_PRI =
Chromaticities(vec2(0.68f, 0.32f), vec2(0.265f, 0.69f), vec2(0.15f, 0.06f), vec2(0.314f, 0.351f) );
const Chromaticities ARRI_ALEXA_WG_PRI =
Chromaticities(vec2(0.684f, 0.313f), vec2(0.221f, 0.848f), vec2(0.0861f, -0.102f), vec2(0.3127f, 0.329f) );
const Chromaticities REC2020_PRI =
Chromaticities(vec2(0.708f, 0.292f), vec2(0.17f, 0.797f), vec2(0.131f, 0.046f), vec2(0.3127f, 0.329f) );
const Chromaticities REC2020_PRI_2012 =
Chromaticities(vec2(0.69977419f,  0.30022581f), vec2(0.22431866f, 0.76476346f), vec2(0.12136517f, 0.0961114f), vec2(0.3127f, 0.329f) );
const Chromaticities ARRI_ALEXA_WG4_PRI =
Chromaticities(vec2(0.7347f,  0.2653f), vec2(0.1424f, 0.8576f), vec2(0.0991f,-0.0308f), vec2(0.3127f, 0.329f) );
const Chromaticities SGAMUT3cine_PRI =
Chromaticities(vec2(0.766f,  0.275f), vec2(0.225f, 0.8f), vec2(0.089f, -0.087f), vec2(0.3127f, 0.329f) );
const Chromaticities SGAMUT3_PRI =
Chromaticities(vec2(0.73f,  0.28f), vec2(0.14f, 0.855f), vec2(0.01f, -0.05f), vec2(0.3127f, 0.329f) );
const Chromaticities EGAMUT_PRI =
Chromaticities(vec2(0.8f,  0.3177f), vec2(0.18f, 0.9f), vec2(0.065f, -0.0805f), vec2(0.3127f, 0.329f) );
const Chromaticities DWGINT_PRI =
Chromaticities(vec2(0.8f,  0.3130f), vec2(0.1682f, 0.9877f), vec2(0.079f, -0.1155f), vec2(0.3127f, 0.329f) );
const Chromaticities SONYA6000_PRI =
Chromaticities(vec2(0.709212f,  0.27432f), vec2(0.219737f, 0.961661f), vec2(0.023252f, -0.305702f), vec2(0.3127f, 0.329f) );
const Chromaticities REDWG_PRI =
Chromaticities(vec2(0.780308f, 0.30425299f), vec2(0.12159501f, 1.49399403f), vec2(0.095612f, -0.084589f), vec2(0.3127f, 0.329f) );
const Chromaticities BLACKMAGICWG_PRI =
Chromaticities(vec2(0.7177215143781699f, 0.3171180860551045f), vec2(0.2280409960285721f, 0.8615690087709122f), vec2(0.10058410063338172f, -0.08204520062464217f), vec2(0.3127f, 0.329f) );
const Chromaticities CANONCINEMA_PRI =
Chromaticities(vec2(0.7400000016535166f, 0.27000000186020623f), vec2(0.17000000222850284f, 1.1400000018352379f), vec2(0.07999999816658841f, -0.09999999770823552f), vec2(0.3127f, 0.329f) );

//vec3 sqrtf3(vec3 a) {
  //// For each component of vec3 a, compute the square-root
  //return vec3(sqrt(a.x), sqrt(a.y), sqrt(a.z));
//}

//vec3 clampf3(vec3 a, float mn, float mx) {
  //// Clamp each component of vec3 a to be between float mn and float mx
  //return vec3(
    //min(max(a.x, mn), mx),
    //min(max(a.y, mn), mx),
    //min(max(a.z, mn), mx)
  //);
//}

//vec3 maxf3(float b, vec3 a) {
  //// For each component of vec3 a, return max of component and float b
  //return vec3(max(a.x, b), max(a.y, b), max(a.z, b));
//}

//vec3 minf3(float b, vec3 a) {
  //// For each component of vec3 a, return min of component and float b
  //return vec3(min(a.x, b), min(a.y, b), min(a.z, b));
//}


//
//vec3 powf3(vec3 a, float b) {
  //// Raise each component of vec3 a to power b
  //return vec3(pow(a.x, b), pow(a.y, b), pow(a.z, b));
//}

//float spowf(float a, float b) {
  //// Compute "safe" power of float a, reflected over the origin
//
  //a=sign(a)*pow(abs(a), b);
  //return a;
//}

//vec3 spowf3(vec3 a, float b) {
  //// Compute "safe" power of vec3 a, reflected over the origin
  //return vec3(
    //sign(a.x)*pow(abs(a.x), b),
    //sign(a.y)*pow(abs(a.y), b),
    //sign(a.z)*pow(abs(a.z), b)
  //);
//}

//float _mixf(float a, float b, float f) {
  //// Linear interpolation between float a and float b by factor f. Extrapolates.
  //return a * (1.0f - f) + b * f;
//}
//
//vec3 _mixf3(vec3 a, vec3 b, float f) {
  //// Linear interpolation between vec3 a and vec3 b by factor f. Extrapolates.
  //return vec3(_mixf(a.x, b.x, f), _mixf(a.y, b.y, f), _mixf(a.z, b.z, f));
//}
//
//vec3 _log2f3(vec3 RGB) {
  //return vec3(log2(RGB.x), log2(RGB.y), log2(RGB.z));
//}
//
//float _smoothstepf(float e0, float e1, float x) {
  //// return smoothstep of float x between e0 and e1
  //x = clamp((x - e0) / (e1 - e0), 0.0f, 1.0f);
  //return x * x * (3.0f - 2.0f * x);
//}
//
//vec3 _smoothstepf3(float e0, float e1, vec3 x) {
  //// return smoothstep of vec3 x between e0 and e1
  //return vec3(_smoothstepf(e0, e1, x.x), _smoothstepf(e0, e1, x.y), _smoothstepf(e0, e1, x.z));
//}

//// Multiply vec3 vector a and 3x3 matrix m
//vec3 mult_f3_f33(vec3 a, mat3 m) {
  //return vec3(
    //m.x.x * a.x + m.x.y * a.y + m.x.z * a.z,
    //m.y.x * a.x + m.y.y * a.y + m.y.z * a.z,
    //m.z.x * a.x + m.z.y * a.y + m.z.z * a.z
  //);
//}
//
//// Calculate inverse of 3x3 matrix: https://stackoverflow.com/questions/983999/simple-3x3-matrix-inverse-code-c
//mat3 inverse(mat3 m) {
  //float d = m.x.x * (m.y.y * m.z.z - m.z.y * m.y.z) -
            //m.x.y * (m.y.x * m.z.z - m.y.z * m.z.x) +
            //m.x.z * (m.y.x * m.z.y - m.y.y * m.z.x);
  //float id = 1.0f / d;
  //mat3 c = identity_mtx;
  //c.x.x = id * (m.y.y * m.z.z - m.z.y * m.y.z);
  //c.x.y = id * (m.x.z * m.z.y - m.x.y * m.z.z);
  //c.x.z = id * (m.x.y * m.y.z - m.x.z * m.y.y);
  //c.y.x = id * (m.y.z * m.z.x - m.y.x * m.z.z);
  //c.y.y = id * (m.x.x * m.z.z - m.x.z * m.z.x);
  //c.y.z = id * (m.y.x * m.x.z - m.x.x * m.y.z);
  //c.z.x = id * (m.y.x * m.z.y - m.z.x * m.y.y);
  //c.z.y = id * (m.z.x * m.x.y - m.x.x * m.z.y);
  //c.z.z = id * (m.x.x * m.y.y - m.y.x * m.x.y);
  //return c;
//}
//
//mat3 transpose_f33( mat3 A) {
  //mat3 B = A;
  //A.x=vec3(B.x.x,B.y.x,B.z.x);
  //A.y=vec3(B.x.y,B.y.y,B.z.y);
  //A.z=vec3(B.x.z,B.y.z,B.z.z);
//
  //return A;
//}
//
//mat3 mult_f33_f33( mat3 A, mat3 B) {
  //A = transpose_f33(A);
  //mat3 C = B;
  //B.x= mult_f3_f33(A.x,C);
  //B.y= mult_f3_f33(A.y,C);
  //B.z= mult_f3_f33(A.z,C);
  //B = transpose_f33(B);
//
  //return B;
//}








float chroma(vec3 rgb, int norm) {
  // Calculate and return classical chroma. If norm, normalize by mx
  float mx = max(rgb.x, max(rgb.y, rgb.z));
  float mn = min(rgb.x, min(rgb.y, rgb.z));
  float ch = mx - mn;
  if (norm == 1) ch = mx == 0.0f ? 0.0f : ch / mx;
  return ch;
}

float hue(vec3 rgb) {
  // Calculate and return hue in degrees between 0 and 6
  float mx = max(rgb.x, max(rgb.y, rgb.z));
  float mn = min(rgb.x, min(rgb.y, rgb.z));
  float ch = mx - mn;
  float h = 0.0;
  if (ch == 0.0f) h = 0.0f;
  else if (mx == rgb.x) h = mod((rgb.y - rgb.z) / ch + 6.0f, 6.0f);
  else if (mx == rgb.y) h = (rgb.z - rgb.x) / ch + 2.0f;
  else if (mx == rgb.z) h = (rgb.x - rgb.y) / ch + 4.0f;
  return h;
}

mat3 RGBtoXYZ( Chromaticities N) {
  mat3 M = mat3(
    vec3(N.red.x/N.red.y, N.green.x / N.green.y, N.blue.x / N.blue.y),
    vec3(1.0, 1.0, 1.0),
    vec3(
      (1.-N.red.x-N.red.y) / N.red.y, (1.-N.green.x-N.green.y) / N.green.y, (1.-N.blue.x-N.blue.y)/N.blue.y
    )
  );
  vec3 wh = vec3(
    N.white.x / N.white.y, 1.0, (1.-N.white.x-N.white.y) / N.white.y
  );
  wh = wh * inverse(M);
  M = mat3(
    vec3(M[0].x*wh.x , M[0].y*wh.y , M[0].z*wh.z),
    vec3(M[1].x*wh.x, M[1].y*wh.y, M[1].z*wh.z),
    vec3(M[2].x*wh.x,M[2].y*wh.y,M[2].z*wh.z)
  );
  return M;
}

mat3 XYZtoRGB( Chromaticities N) {
  mat3 M = inverse(RGBtoXYZ(N));
  return M;
}

Chromaticities Insetcalc(Chromaticities N,float cpr,float cpg,float cpb){
  vec3 scale = vec3(
    1.0 / pow(1.0 - cpr, 2.0),
    1.0 / pow(1.0 - cpg, 2.0),
    1.0 / pow(1.0 - cpb, 2.0)
  );

  Chromaticities adj = Chromaticities(
    vec2(
      (N.red.x - N.white.x) * scale.x + N.white.x,
      (N.red.y-N.white.y) * scale.x + N.white.y
    ),
    vec2(
      (N.green.x - N.white.x) * scale.y + N.white.x,
      (N.green.y - N.white.y) * scale.y + N.white.y
    ),
    vec2(
      (N.blue.x - N.white.x) * scale.z + N.white.x,
      (N.blue.y - N.white.y) * scale.z + N.white.y
    ),
    vec2(N.white.x, N.white.y)
  );

  return adj;
}

mat3 Insetcalcmatrix(Chromaticities N,float cpr,float cpg,float cpb){
  vec3 scale = vec3(1./pow(1.-cpr,2.),1./pow(1.-cpg,2.),1./pow(1.-cpb,2.));

  Chromaticities adj = Chromaticities(vec2((N.red.x-N.white.x)*scale.x+N.white.x,(N.red.y-N.white.y)*scale.x+N.white.y),
      vec2((N.green.x-N.white.x)*scale.y+N.white.x,(N.green.y-N.white.y)*scale.y+N.white.y),
      vec2((N.blue.x-N.white.x)*scale.z+N.white.x,(N.blue.y-N.white.y)*scale.z+N.white.y),vec2(N.white.x,N.white.y));

  mat3 In2XYZ = RGBtoXYZ(N);
  mat3 XYZ2Adj = XYZtoRGB(adj);

  mat3 RGBtoAdj = In2XYZ * XYZ2Adj;

  return RGBtoAdj;
}

Chromaticities RotatePrimaries(Chromaticities N,float ored,float og,float ob)
{
  ored = radians(ored);
  og =radians(og);
  ob = radians(ob);
  vec2 Cred= vec2(N.red.x-N.white.x,N.red.y-N.white.y);
  vec2 Cgreen = vec2(N.green.x-N.white.x,N.green.y-N.white.y);
  vec2 Cblue = vec2(N.blue.x-N.white.x,N.blue.y-N.white.y);
  vec3 l = vec3(length(vec2(Cred.x,Cred.y)), length(vec2(Cgreen.x,Cgreen.y)), length(vec2(Cblue.x,Cblue.y))); // I think _hypotf is equivalent to length
  vec3 hue = vec3( atan(Cred.y,Cred.x), atan(Cgreen.y,Cgreen.x), atan(Cblue.y,Cblue.x));
  Chromaticities Nout = Chromaticities(vec2(l.x*cos(hue.x+ored),l.x*sin(hue.x+ored)),vec2(l.x*cos(hue.y+og),l.x*sin(hue.y+og)),vec2(l.x*cos(hue.z+ob),l.x*sin(hue.z+ob)),N.white);
  Nout.red.x= Nout.red.x+N.white.x;
  Nout.red.y=Nout.red.y+N.white.y;
  Nout.green.x=Nout.green.x+N.white.x;
  Nout.green.y=Nout.green.y+N.white.y;
  Nout.blue.x=Nout.blue.x+N.white.x;
  Nout.blue.y=Nout.blue.y+N.white.y;

  return Nout;
}

Chromaticities Primaries2Moment(Chromaticities N){
  vec2 momr = vec2((N.red.x-N.white.x)/N.red.y,(N.red.y-N.white.y)/N.red.y);
  vec2 momg = vec2((N.green.x-N.white.x)/N.green.y,(N.green.y-N.white.y)/N.green.y);
  vec2 momb = vec2((N.blue.x-N.white.x)/N.blue.y,(N.blue.y-N.white.y)/N.blue.y);

  Chromaticities M = Chromaticities(momr,momg,momb,N.white);

  return M;
}

Chromaticities CenterPrimaries(Chromaticities N){
  N.red.x = N.red.x-N.white.x;
  N.red.y = N.red.y-N.white.y;
  N.green.x = N.green.x-N.white.x;
  N.green.y = N.green.y-N.white.y;
  N.blue.x = N.blue.x-N.white.x;
  N.blue.y = N.blue.y-N.white.y;

  return N;
}

Chromaticities DeCenterPrimaries(Chromaticities N){
  N.red.x = N.red.x+N.white.x;
  N.red.y = N.red.y+N.white.y;
  N.green.x = N.green.x+N.white.x;
  N.green.y = N.green.y+N.white.y;
  N.blue.x = N.blue.x+N.white.x;
  N.blue.y = N.blue.y+N.white.y;

  return N;
}

Chromaticities ScalePrim(Chromaticities N,float rs,float gs,float bs){
  N = CenterPrimaries(N);

  N.red = vec2(N.red.x*rs,N.red.y*rs);
  N.green = vec2(N.green.x*gs,N.green.y*gs);
  N.blue = vec2(N.blue.x*bs,N.blue.y*bs);

  N = DeCenterPrimaries(N);

  return N;
}

vec2 cartesian_to_polar2(vec2 a) {
  vec2 b = a;
  b.y = atan(a.y,a.x);

  return vec2(sqrt(a.x*a.x+ a.y*a.y),b.y);
}

vec2 polar_to_cartesian2(vec2 a) {

  return vec2(a.x * cos(a.y), a.x * sin(a.y));
}

Chromaticities RotatePrimary(Chromaticities N,float rrot,float grot,float brot){
  //rotatation parameter excepted in degrees, but internally transformed to radians

  N = CenterPrimaries(N);
  N.red = cartesian_to_polar2(N.red);
  N.green = cartesian_to_polar2(N.green);
  N.blue = cartesian_to_polar2(N.blue);

  rrot = radians(rrot);
  grot = radians(grot);
  brot = radians(brot);

  N.red.y = N.red.y + rrot;
  N.green.y = N.green.y + grot;
  N.blue.y = N.blue.y + brot;

  N.red = polar_to_cartesian2(N.red);
  N.green = polar_to_cartesian2(N.green);
  N.blue = polar_to_cartesian2(N.blue);

  N = DeCenterPrimaries(N);

  return N;
}

vec2 Line_equation (vec2 a,vec2 b){
  float m = (b.y-a.y)/(b.x - a.x);
  float c = a.y - m*a.x;

  vec2 line = vec2(m,c);

  return line;
}

Chromaticities PrimariesLines(Chromaticities N){
    Chromaticities M = N;

    N.red = Line_equation(M.red,M.white);
    N.green = Line_equation(M.green,M.white);
    N.blue = Line_equation(M.blue,M.white);

    return N;
}

Chromaticities Polygon(Chromaticities N){
  Chromaticities M = N;

  N.red = Line_equation(M.red,M.green);
  N.green = Line_equation(M.red,M.blue);
  N.blue = Line_equation(M.blue,M.green);

  return N;
}

vec2 intersection(vec2 a,vec2 b){
  //Calculate the xy coordinates where 2 lines intersect
  vec2 c = a;
  vec2 d = b;

  a.x = (d.y-c.y)/(c.x-d.x);
  a.y = a.x*c.x+c.y;

  return a;
}

Chromaticities InsetPrimaries(Chromaticities N,float cpr,float cpg,float cpb,float ored,float og,float ob){
  Chromaticities M = N;
  float arbitrary_scale = 2.0; // This scale can be removed entirely when using EaryChow's version, presumably because the inset and outset matrices negate each other
  N = ScalePrim(N, arbitrary_scale, arbitrary_scale, arbitrary_scale);

  N = RotatePrimary(N,ored,og,ob);

  M = Polygon(M);

  vec2 redline = ored>0.? M.red:M.green;
  vec2 greenline = og>0.? M.blue:M.red;
  vec2 blueline = ob>0.? M.green:M.blue;

  //this are the lines from wp to scaled, needed to find intersection with polygon
  N = PrimariesLines(N);
  N.red = intersection(N.red,redline);
  N.green = intersection(N.green,greenline);
  N.blue = intersection(N.blue,blueline);

  cpr = 1.-cpr;
  cpg = 1.-cpg;
  cpb = 1.-cpb;

  N = ScalePrim(N,cpr,cpg,cpb);

  return N;
}

Chromaticities MomentBoundary(Chromaticities N){
  vec2 momr = vec2((N.red.x-N.white.x)/N.red.y,(N.red.y-N.white.y)/N.red.y);
  vec2 momg = vec2((N.green.x-N.white.x)/N.green.y,(N.green.y-N.white.y)/N.green.y);
  vec2 momb = vec2((N.blue.x-N.white.x)/N.blue.y,(N.blue.y-N.white.y)/N.blue.y);

  float r2gslope = (momg.y-momr.y)/(momg.x-momr.x);
  float r2gint = (momr.y-r2gslope*momr.x);
  float r2bslope = (momb.y-momr.y)/(momb.x-momr.x);
  float r2bint = (momr.y-r2bslope*momr.x);
  float g2bslope = (momb.y-momg.y)/(momb.x-momg.x);
  float g2bint = (momb.y-g2bslope*momb.x);

  Chromaticities M = Chromaticities(vec2(r2gslope,r2gint),vec2(r2bslope,r2bint),vec2(g2bslope,g2bint),N.white);

  return M;
}

mat3 RGBtoRGB(Chromaticities N,Chromaticities M){
  mat3 In2XYZ = RGBtoXYZ(N);
  mat3 XYZ2Out = XYZtoRGB(M);

  mat3 rgbtorgb = In2XYZ * XYZ2Out;

  rgbtorgb = transpose(rgbtorgb);
  return rgbtorgb;
}

mat3 InsetMatrix(Chromaticities N,float cpr,float cpg,float cpb,float oRed,float og,float ob){
  Chromaticities In = Insetcalc(N,cpr,cpg,cpb);
  In=RotatePrimaries(In,oRed,og,ob);
  mat3 Matrix = RGBtoRGB(N,In);

  return Matrix;
}

vec3 XYZ_2_xyY( vec3 XYZ) {
  vec3 xyY;
  //float divisor = (abs(XYZ.x) + abs(XYZ.y) + abs(XYZ.z));
  float divisor = ((XYZ.x) + XYZ.y + XYZ.z);
  //if (divisor == 0.0f) divisor = 1e-10f;
  xyY.x =divisor == 0.0f? 0.0f:(XYZ.x) / divisor;
  xyY.y = divisor == 0.0f? 0.0f:(XYZ.y)/ divisor;
  //xyY.z = abs(XYZ.y);
  xyY.z = XYZ.y;
  return xyY;
}

vec3 xyY_2_XYZ( vec3 xyY) {
  vec3 XYZ;
  //XYZ.x = xyY.x * xyY.z / max( xyY.y, 1e-10f);
  XYZ.x = xyY.y==0.0f? 0.0f: xyY.x * xyY.z / xyY.y;
  XYZ.y = xyY.z;
  //XYZ.z = (1.0f - xyY.x - xyY.y) * xyY.z / max( xyY.y, 1e-10f);
  XYZ.z = xyY.y==0.0f? 0.0f: (1.0f - xyY.x - xyY.y) * xyY.z /( xyY.y);
  return XYZ;
}