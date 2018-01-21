extern vec2 screen;
extern Image refraction;
extern Image background;

extern number strength;
extern vec2 offset;
extern vec2 size;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
  vec4 vector         = Texel(refraction, texture_coords.xy);
  vec2 position       = offset + texture_coords / (screen / size);
  vec2 refract_vector = vec2(2.0 * strength * (vector.x - 0.5) / screen.x, 2.0 * strength * (vector.y - 0.5) / screen.y);
  
  return Texel(background, position + refract_vector);
}