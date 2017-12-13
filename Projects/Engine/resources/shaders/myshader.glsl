vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = Texel(texture, texture_coords);
    return vec4(colour.r, colour.g, colour.b, texturecolor.a);
}