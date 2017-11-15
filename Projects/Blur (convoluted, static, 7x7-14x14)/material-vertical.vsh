uniform float prescaler;
varying vec2 vBlurOffsets[14];

vec4 position(mat4 transformProjection, vec4 vertexPosition){
  vBlurOffsets[ 0] = VertexTexCoord.xy + prescaler*vec2(0.0, -7)/love_ScreenSize.y;
  vBlurOffsets[ 1] = VertexTexCoord.xy + prescaler*vec2(0.0, -6)/love_ScreenSize.y;
  vBlurOffsets[ 2] = VertexTexCoord.xy + prescaler*vec2(0.0, -5)/love_ScreenSize.y;
  vBlurOffsets[ 3] = VertexTexCoord.xy + prescaler*vec2(0.0, -4)/love_ScreenSize.y;
  vBlurOffsets[ 4] = VertexTexCoord.xy + prescaler*vec2(0.0, -3)/love_ScreenSize.y;
  vBlurOffsets[ 5] = VertexTexCoord.xy + prescaler*vec2(0.0, -2)/love_ScreenSize.y;
  vBlurOffsets[ 6] = VertexTexCoord.xy + prescaler*vec2(0.0, -1)/love_ScreenSize.y;
  vBlurOffsets[ 7] = VertexTexCoord.xy + prescaler*vec2(0.0,  1)/love_ScreenSize.y;
  vBlurOffsets[ 8] = VertexTexCoord.xy + prescaler*vec2(0.0,  2)/love_ScreenSize.y;
  vBlurOffsets[ 9] = VertexTexCoord.xy + prescaler*vec2(0.0,  3)/love_ScreenSize.y;
  vBlurOffsets[10] = VertexTexCoord.xy + prescaler*vec2(0.0,  4)/love_ScreenSize.y;
  vBlurOffsets[11] = VertexTexCoord.xy + prescaler*vec2(0.0,  5)/love_ScreenSize.y;
  vBlurOffsets[12] = VertexTexCoord.xy + prescaler*vec2(0.0,  6)/love_ScreenSize.y;
  vBlurOffsets[13] = VertexTexCoord.xy + prescaler*vec2(0.0,  7)/love_ScreenSize.y;
  return transformProjection * vertexPosition;
}
