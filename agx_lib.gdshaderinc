struct Chromaticities {
    vec2 red;
    vec2 green;
    vec2 blue;
    vec2 white;
};

Chromaticities make_chromaticities( vec2 A, vec2 B, vec2 C, vec2 D) {
  Chromaticities F;
  F.red = A; F.green = B; F.blue = C; F.white = D;
  return F;
}


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

  Chromaticities adj = make_chromaticities(
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

  Chromaticities adj = make_chromaticities(vec2((N.red.x-N.white.x)*scale.x+N.white.x,(N.red.y-N.white.y)*scale.x+N.white.y),
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
  Chromaticities Nout = make_chromaticities(vec2(l.x*cos(hue.x+ored),l.x*sin(hue.x+ored)),vec2(l.x*cos(hue.y+og),l.x*sin(hue.y+og)),vec2(l.x*cos(hue.z+ob),l.x*sin(hue.z+ob)),N.white);
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

  Chromaticities M = make_chromaticities(momr,momg,momb,N.white);

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
  N = ScalePrim(N, 2.0, 2.0, 2.0);

  N = RotatePrimary(N,ored,og,ob);

  M= Polygon(M);

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

  Chromaticities M = make_chromaticities(vec2(r2gslope,r2gint),vec2(r2bslope,r2bint),vec2(g2bslope,g2bint),N.white);

  return M;
}

mat3 RGBtoRGB(Chromaticities N,Chromaticities M){
  mat3 In2XYZ = RGBtoXYZ(N);
  mat3 XYZ2Out = XYZtoRGB(M);

  mat3 rgbtorgb = In2XYZ * XYZ2Out;

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