// This shader is only here to help you understand how a very basic box blur works.
// It should not be used as it's fairly inefficient and doesn't look as good as
// a gaussian blur. Look at the "Blur (convoluted)" examples instead.
extern float blurRadius;
#define SAMPLE_RANGE 4
vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  vec4 sum = vec4(0);
  for(int x = -SAMPLE_RANGE; x < SAMPLE_RANGE + 1; x++){
    for(int y = -SAMPLE_RANGE; y < SAMPLE_RANGE + 1; y++){
      // textureOffset
      sum += Texel(currentTexture, texCoords + blurRadius*vec2(x, y)/love_ScreenSize.xy);
    }
  }
  sum = sum/(2*SAMPLE_RANGE*2*SAMPLE_RANGE);
  sum.a = 1.0;
  return sum;
}
