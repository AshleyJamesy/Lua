extern vec2 step;

vec4 effect(vec4 colour, Image texture, vec2 texturePos, vec2 screenPos)
{
	number alpha = 4 * texture2D(texture, texturePos).a;
	alpha -= texture2D(texture, texturePos + vec2(step.x, 0.0f)).a;
	alpha -= texture2D(texture, texturePos + vec2(-step.x, 0.0f)).a;
	alpha -= texture2D(texture, texturePos + vec2(0.0f, step.y)).a;
	alpha -= texture2D(texture, texturePos + vec2(0.0f, -step.y)).a;

	return vec4(colour.r, colour.g, colour.b, alpha * colour.a);
}
