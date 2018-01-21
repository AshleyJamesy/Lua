extern int rows;
extern int columns;
extern int index;

vec4 tile(int i, Image tex, vec2 _coords)
{
	vec2 quad = vec2(mod(i, columns), i / columns);
	vec2 size = 1.0 / vec2(columns, rows);
	
	return Texel(tex, _coords * size + size * quad);
}

vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
{
	return tile(index, texture, uv_coords);
}