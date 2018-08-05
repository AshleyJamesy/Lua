extern float steps;
extern float intensity;
extern float direction;

vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
{
	vec2 size   	= 1.0 / love_ScreenSize.xy;
	vec4 result 	= Texel(texture, uv_coords);
	vec2 direction 	= abs(vec2(1.0 - direction, direction));

	for(float i = 1.0; i <= steps; i += 1.0)
	{
			result = result + Texel(texture, vec2(uv_coords.x - size.x * i * direction.x, uv_coords.y - size.y * i * direction.y));
			result = result + Texel(texture, vec2(uv_coords.x + size.x * i * direction.x, uv_coords.y + size.y * i * direction.y));
	}

	result   = result / (steps * 2.0 + 1.0) * intensity;
	result.a = 1.0;
	
	return result;
}