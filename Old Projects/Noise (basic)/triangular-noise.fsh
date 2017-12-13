// http://loopit.dk/banding_in_games.pdf
// floor(signal + hash(seed1)+hash(seed2)-0.5) => [-0.5;1.5[

uniform vec2 seed;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec4 ditherRGBATriangular(vec4 inColor){
  return inColor + vec4(rand(gl_FragCoord.xy + seed) + rand(gl_FragCoord.xy - seed) - 0.5)/255.0;
}

vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  return ditherRGBATriangular(vec4(vec3(texCoords.x)*color.rgb, 1.0));
}
