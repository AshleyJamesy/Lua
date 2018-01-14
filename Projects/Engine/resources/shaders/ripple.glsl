extern vec2 screen = vec2(800.0, 600.0);
extern float time  = 0.0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    vec2 cPos = -1.0 + 2.0 * pixel_coords.xy / screen.xy;
    float cLength = length(cPos);
    
    vec2 uv = pixel_coords.xy / screen.xy + (cPos/cLength) * cos(cLength * 12.0 - time * 4.0) * 0.03;
    vec3 col = Texel(texture, uv).xyz;
    
    return vec4(col,1.0);
}