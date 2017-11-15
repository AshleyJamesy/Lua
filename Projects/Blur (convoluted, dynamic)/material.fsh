varying vec2 vBlurOffsets[${{NUM_BLUR_SAMPLES}}];

vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  vec4 pixelColor = vec4(0.0);
  
  ${{GENERATE_BLUR_WEIGHTINGS}}

  pixelColor.a = 1.0;
  return pixelColor;
}
