extern Image backbuffer;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
    vec2 pixel_ScreenPos = pixel_coords.xy / love_ScreenSize.xy;
    
    return vec4(Texel(backbuffer, pixel_ScreenPos).xyz, 1.0);
}