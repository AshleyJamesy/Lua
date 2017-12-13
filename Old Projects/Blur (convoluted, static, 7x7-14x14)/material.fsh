varying vec2 vBlurOffsets[14];

vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  vec4 pixelColor = vec4(0.0);
  pixelColor += Texel(currentTexture, vBlurOffsets[ 0])*0.0044299121055113265;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 1])*0.00895781211794;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 2])*0.0215963866053;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 3])*0.0443683338718;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 4])*0.0776744219933;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 5])*0.115876621105;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 6])*0.147308056121;
  pixelColor += Texel(currentTexture, texCoords       )*0.159576912161;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 7])*0.147308056121;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 8])*0.115876621105;
  pixelColor += Texel(currentTexture, vBlurOffsets[ 9])*0.0776744219933;
  pixelColor += Texel(currentTexture, vBlurOffsets[10])*0.0443683338718;
  pixelColor += Texel(currentTexture, vBlurOffsets[11])*0.0215963866053;
  pixelColor += Texel(currentTexture, vBlurOffsets[12])*0.00895781211794;
  pixelColor += Texel(currentTexture, vBlurOffsets[13])*0.0044299121055113265;
  return pixelColor;
}
