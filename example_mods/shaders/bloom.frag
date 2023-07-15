//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage.
//SHADERTOY PORT FIX

//BLOOM SHADER BY BBPANZU

const float amount = 2.0;

// GAUSSIAN BLUR SETTINGS
float dim = 1.4;
float Directions = 16.0;
float Quality = 8.0; 
float Size = 18.0; 
vec2 Radius = Size/openfl_TextureSize.xy;

void main(void)
{ 

precision highp float;

#define PI 3.1415926535897932384626433832795

/******************************************************************************
 * This shader simulates three kinds of color blindness, and does so more     *
 * accurately than most other shaders of this kind. The xy coordinates for    *
 * the LMS colorspace that I use are calculated from the 'cone fundamentals'  *
 * for the human eye.                                                         *
 *                                                                            *
 * Most other shaders around here which use pre-existing XYZ->LMS matrices    *
 * that were designed not for color blindness research, but instead for       *
 * approximating how our eyes perform white balance, among other photography  *
 * color issues.                                                              *
 ******************************************************************************/


struct transfer {
	float power;
	float off;
	float slope;
	float cutoffToLinear;
	float cutoffToGamma;
};

struct rgb_space {
	mat3 primaries;
	vec3 white;
	transfer trc;
};


/*
 * Preprocessor 'functions' that help build colorspaces as constants
 */

// Turns 6 chromaticity coordinates into a 3x3 matrix
#define Primaries(r1, r2, g1, g2, b1, b2)\
	mat3(\
		(r1), (r2), 1.0 - (r1) - (r2),\
		(g1), (g2), 1.0 - (g1) - (g2),\
		(b1), (b2), 1.0 - (b1) - (b2))

// Creates a whitepoint's xyz chromaticity coordinates from the given xy coordinates
#define White(x, y)\
	vec3((x), (y), 1.0 - (x) - (y))/(y)

// Creates a scaling matrix using a vec3 to set the xyz scalars
#define diag(v)\
	mat3(\
		(v).x, 0.0, 0.0,\
		0.0, (v).y, 0.0,\
		0.0, 0.0, (v).z)

// Creates a conversion matrix that turns RGB colors into XYZ colors
#define rgbToXyz(space)\
	space.primaries*diag(inverse((space).primaries)*(space).white)

// Creates a conversion matrix that turns XYZ colors into RGB colors
#define xyzToRgb(space)\
	inverse(rgbToXyz(space))

// Creates a conversion matrix converts linear RGB colors from one colorspace to another
#define conversionMatrix(f, t)\
	xyzToRgb(t)*rgbToXyz(f)


/*
 * Chromaticities for RGB primaries
 */

// CIE 1931 RGB
const mat3 primariesCie = Primaries(
	0.72329, 0.27671,
	0.28557, 0.71045,
	0.15235, 0.02
);

// Identity RGB
//const mat3 primariesIdentity = mat3(1.0);



// Rec. 709 (HDTV) and sRGB primaries
const mat3 primaries709 = Primaries(
	0.64, 0.33,
	0.3, 0.6,
	0.15, 0.06
);



// LMS primaries as chromaticity coordinates, computed from
// http://www.cvrl.org/ciepr8dp.htm, and
// http://www.cvrl.org/database/text/cienewxyz/cie2012xyz2.htm
const mat3 primariesLms = Primaries(
	0.73840145, 0.26159855,
	1.32671635, -0.32671635,
	0.15861916, 0.0
);


/*
 * Chromaticities for white points
 */

// Standard illuminant E (also known as the 'equal energy' white point)
const vec3 whiteE = White(1.0/3.0, 1.0/3.0);

// Standard illuminant D65. Note that there are more digits here than specified
// in either sRGB or Rec 709, so in some cases results may differ from other
// software. Color temperature is roughly 6504 K (originally 6500K, but complex
// science stuff made them realize that was innaccurate)
const vec3 whiteD65 = White(0.312713, 0.329016);




/*
 * Gamma curve parameters
 */

// Linear gamma
const transfer gam10 = transfer(1.0, 0.0, 1.0, 0.0, 0.0);

// Gamma for sRGB. Besides being full-range (0-255 values), this is the only
// difference between sRGB and Rec. 709.
const transfer gamSrgb = transfer(2.4, 0.055, 12.92, 0.04045, 0.0031308);


/*
 * RGB Colorspaces
 */
// Lms primaries, balanced against equal energy white point
const rgb_space LmsRgb = rgb_space(primariesLms, whiteE, gam10);


/*
 * Settings
 */

// Choose RGB colorspace for the display
const rgb_space space = rgb_space(primaries709, whiteD65, gamSrgb);

const mat3 toXyz = rgbToXyz(space);
const mat3 toRgb = xyzToRgb(space);

// Use LMS primaries instead of a pre-created matrix
const mat3 toLms = xyzToRgb(LmsRgb);


/*
 * Conversion Functions
 */

vec3 toLinear(vec3 color, transfer trc)
{
	bvec3 cutoff = lessThan(color, vec3(trc.cutoffToLinear));
	bvec3 negCutoff = lessThanEqual(color, vec3(-1.0*trc.cutoffToLinear));
	vec3 higher = pow((color + trc.off)/(1.0 + trc.off), vec3(trc.power));
	vec3 lower = color/trc.slope;
	vec3 neg = -1.0*pow((color - trc.off)/(-1.0 - trc.off), vec3(trc.power));

	color = mix(higher, lower, cutoff);
	color = mix(color, neg, negCutoff);

	return color;
}

vec3 toGamma(vec3 color, transfer trc)
{
	bvec3 cutoff = lessThan(color, vec3(trc.cutoffToGamma));
	bvec3 negCutoff = lessThanEqual(color, vec3(-1.0*trc.cutoffToGamma));
	vec3 higher = (1.0 + trc.off)*pow(color, vec3(1.0/trc.power)) - trc.off;
	vec3 lower = color*trc.slope;
	vec3 neg = (-1.0 - trc.off)*pow(-1.0*color, vec3(1.0/trc.power)) + trc.off;

	color = mix(higher, lower, cutoff);
	color = mix(color, neg, negCutoff);

	return color;
}

// Scales a color to the closest in-gamut representation of that color
vec3 gamutScale(vec3 color, float luma)
{
	float low = min(color.r, min(color.g, min(color.b, 0.0)));
	float high = max(color.r, max(color.g, max(color.b, 1.0)));

	float lowScale = low/(low - luma);
	float highScale = (high - 1.0)/(high - luma);
	float scale = max(lowScale, highScale);
	color += scale*(luma - color);

	return color;
}

vec3 convert(vec3 color, float multp)
{
	// Convert to XYZ and grab luma
	color = toXyz*color;
	float luma = color.y;

	// Convert to LMS
	color = toLms*color;

	// Calculate color blindness simulation adaptation matrix variables
	// such that the given two colors remain the same
	const vec3 white = toLms*space.white;
	const vec3 blue = toLms*space.primaries[2];
	const vec3 red = toLms*space.primaries[0];

	const vec2 prota = inverse(mat2(
		white.g, blue.g,
		white.b, blue.b
	))*vec2(white.r, blue.r);
	
	// Perform color blindness adjustments
	// I'm using 3 separate matrices (as of 2018-02-11) to allow simulating
	// mixed types of color blindness (not sure how accurate it is though)
	mat3 adaptProta = mat3(
		1.0 - multp, 0.0, 0.0,
		prota.x*multp, 1.0, 0.0,
		prota.y*multp, 0.0, 1.0
	);

	//color = adaptTrita*adaptDeuta*adaptProta*color;
	color = adaptProta*color;

	// Convert back to XYZ
	color = inverse(toLms)*color;


	// Convert to RGB
	color = toRgb*color;
	color = gamutScale(color, luma);

	return color;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec3 color;
	float iRes = (iResolution.x, iResolution.y * -10.0);
    vec2 texCoord = iRes/fragCoord.xy;
    texCoord = fragCoord.xy/iResolution.xy;

	// 0.0 is neutral, 1.0 is max simulation, -1.0 is max correction
    float amount = 0.7;

	fragColor = texture(iChannel0, texCoord);
	color = toLinear(fragColor.rgb, space.trc);

	// Control how much of each variant of colorblindness is simulated
	vec3 prota = convert(color, amount);

	// Calculate which quadrant is being computed
	int quadrant = int(dot(round(fragCoord/iResolution.xy), vec2(1.0, 2.0)));

	// Color each pixel depending on said quadrant
	color = mix(prota, color, bvec3(0));

	color = toGamma(color, space.trc);

	fragColor.rgb = color;
}

}