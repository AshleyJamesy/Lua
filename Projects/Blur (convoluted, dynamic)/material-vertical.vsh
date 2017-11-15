uniform float prescaler;
varying vec2 vBlurOffsets[${{NUM_BLUR_SAMPLES}}];

vec4 position(mat4 transformProjection, vec4 vertexPosition){
  ${{POPULATE_BLUR_OFFSETS}}
  return transformProjection * vertexPosition;
}
