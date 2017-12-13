uniform float prescaler;
varying vec2 vBlurOffsets[14];

vec4 position(mat4 transformProjection, vec4 vertexPosition){
  vBlurOffsets[ 0] = VertexTexCoord.xy + prescaler*vec2(-7, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 1] = VertexTexCoord.xy + prescaler*vec2(-6, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 2] = VertexTexCoord.xy + prescaler*vec2(-5, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 3] = VertexTexCoord.xy + prescaler*vec2(-4, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 4] = VertexTexCoord.xy + prescaler*vec2(-3, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 5] = VertexTexCoord.xy + prescaler*vec2(-2, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 6] = VertexTexCoord.xy + prescaler*vec2(-1, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 7] = VertexTexCoord.xy + prescaler*vec2( 1, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 8] = VertexTexCoord.xy + prescaler*vec2( 2, 0.0)/love_ScreenSize.x;
  vBlurOffsets[ 9] = VertexTexCoord.xy + prescaler*vec2( 3, 0.0)/love_ScreenSize.x;
  vBlurOffsets[10] = VertexTexCoord.xy + prescaler*vec2( 4, 0.0)/love_ScreenSize.x;
  vBlurOffsets[11] = VertexTexCoord.xy + prescaler*vec2( 5, 0.0)/love_ScreenSize.x;
  vBlurOffsets[12] = VertexTexCoord.xy + prescaler*vec2( 6, 0.0)/love_ScreenSize.x;
  vBlurOffsets[13] = VertexTexCoord.xy + prescaler*vec2( 7, 0.0)/love_ScreenSize.x;
  return transformProjection * vertexPosition;
}
