extern Image 	emission;
extern vec4 	emission_colour;

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 d = Texel(texture, texture_coords);
	vec4 e = Texel(emission, texture_coords);
	
	//emission
	float brightness = (e.r + e.g + e.b) * 0.333333333;
	
	if(brightness > 0.0)
	{
		vec4 col = vec4(emission_colour.r, emission_colour.g, emission_colour.b, 1.0);
		return e * col * d.a;
	}
	
	return vec4(0, 0, 0, 1.0) * d.a;
}