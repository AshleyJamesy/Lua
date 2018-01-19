extern float pixels;
extern float intensity;
extern float time;

vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
{
	vec2 size = 1.0 / love_ScreenSize.xy;
	
	float brightness  = 1.0;
	float amplitude   = sign(cos(time * 80.0));
	
	vec4 diffuse = Texel(texture,
			vec2(
				uv_coords.x + (step(mod(uv_coords.y * love_ScreenSize.y, pixels), pixels * 0.5) - 0.5) * 2.0 * 0.001 * intensity * sin(time * 5.0),
					uv_coords.y
			)
		);
	
	float red     = diffuse.r;
	float green   = diffuse.g;
	float blue    = diffuse.b;
	
	vec4 result = vec4(diffuse.xyz, 1.0) * brightness;

	if(mod((uv_coords.y + mod(time * 0.08, 2.0)) * love_ScreenSize.y, pixels) < pixels * 0.5)
	{
		result = result * 0.75;
		result.r = result.r * 0.25;
	}
	else
	{
			result.b = result.b * 0.5;
	}
		
	return vec4(result.xyz, 1.0);
}