vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  return vec4(vec3(texCoords.x)*color.rgb, 1.0);
}
