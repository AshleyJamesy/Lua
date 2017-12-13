vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  float dist = distance(texCoords, vec2(.5, .5));
  vec3 pixelColor = Texel(currentTexture, texCoords).xyz * smoothstep(.75, .4, dist);
  return vec4(pixelColor, 1.0);
}


/*
   vec3 rgb = texture2D(Image, gl_TexCoord[0].xy).xyz;
  float d = distance(gl_TexCoord[0].xy, vec2(0.5,0.5));
  rgb *= smoothstep(Vignette.x, Vignette.y, d);
  gl_FragColor = vec4(vec3(rgb),1.0);
*/
