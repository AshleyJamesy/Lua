#version 330 core

in vec2 i_texture;

out vec4 o_colour;

uniform sampler2D u_samplers[8];

uniform uint u_index;
uniform vec2 u_count;

void main()
{
	int qvx = int(mod(u_index, u_count.x));
	int qvy = int(u_index / u_count.x);
	
	vec2 tile = 1 / u_count;

	o_colour = texture2D(u_samplers[0], i_texture * tile + (tile * vec2(qvx, qvy)));
}