extern float distortionFactor; // 0.05
extern vec2 vignetteEndpoints; // .75, .4

vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  float dist = distance(texCoords, vec2(.5, .5));
  float vignetteFactor = smoothstep(vignetteEndpoints.x, vignetteEndpoints.y, dist);
  
  vec2 centerVector = vec2(0.5, 0.5) - texCoords;
  float centerVectorLength = length(centerVector);
  
  vec3 pixelColor;
  pixelColor.r = Texel(currentTexture, texCoords + (distortionFactor+0.015*(1-vignetteFactor))*vignetteFactor*centerVector).r*vignetteFactor;
  pixelColor.g = Texel(currentTexture, texCoords + distortionFactor*vignetteFactor*centerVector).g*vignetteFactor;
  pixelColor.b = Texel(currentTexture, texCoords + (distortionFactor-0.015*(1-vignetteFactor))*vignetteFactor*centerVector).b*vignetteFactor;
  
  return vec4(pixelColor, 1.0);
}
