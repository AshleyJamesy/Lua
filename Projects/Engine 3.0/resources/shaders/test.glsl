extern vec2 screen_dimensions;
extern Image texture_cubemap;
extern Image texture_emission;
extern Image texture_refraction;
extern float time;
extern float strength;

float opacity 		= 0.0;

vec4 base			= vec4(0.0, 0.0, 0.0, 1.0);
vec4 emission		= vec4(0.0, 0.0, 0.0, 1.0);
vec4 normal			= vec4(0.0, 0.0, 0.0, 1.0);
vec4 refraction 	= vec4(0.0, 0.0, 0.0, 1.0);
vec4 frag_Colour 	= vec4(1.0, 1.0, 1.0, 1.0);

vec4 effect(vec4 colour, Image texture_diffuse, vec2 uv_coords, vec2 screen_coords)
{
	float sx = (screen_coords.x - 0.5) / screen_dimensions.x;
	float sy = (screen_coords.y - 0.5) / screen_dimensions.y;
	
	base = Texel(texture_diffuse, uv_coords.xy);

	vec4 refraction = Texel(texture_refraction, uv_coords.xy);
	refraction 	= Texel(texture_cubemap, vec2(
			sx - (sx * ((refraction.r - 0.5) * 2.0) * 0.01 * strength), 
			sy - (sy * ((refraction.b - 0.5) * 2.0) * 0.01 * strength)
		)
	);
	
	frag_Colour = mix(base, refraction, 1.0 - opacity) * colour;
	
	return frag_Colour;
}