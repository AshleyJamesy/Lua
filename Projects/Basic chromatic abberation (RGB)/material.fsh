extern vec2 abberationVector;

vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  vec4 finalColor = vec4(1);
  finalColor.r = Texel(currentTexture, texCoords.xy + abberationVector).r;
  finalColor.g = Texel(currentTexture, texCoords.xy).g;
  finalColor.b = Texel(currentTexture, texCoords.xy - abberationVector).b;
  return finalColor;
}
