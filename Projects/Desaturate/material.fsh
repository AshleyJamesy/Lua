float desaturateLightness(vec4 inputColor){
  // Desaturate by lightness
  float color = 0.5*(
		     max(inputColor.r, max(inputColor.g, inputColor.b))
		     + min(inputColor.r, min(inputColor.g, inputColor.b))
		     );
  return color;
}

float desaturateMean(vec4 inputColor){
  // Desaturate by mean
  return (inputColor.r + inputColor.g + inputColor.b)/3.0;
}

float desaturateMax(vec4 inputColor){
  // Desaturate by max
  return max(inputColor.r, max(inputColor.g, inputColor.b));
}

float desaturateMin(vec4 inputColor){
  // Desaturate by min
  return min(inputColor.r, min(inputColor.g, inputColor.b));
}

float desaturateLuminosity(vec4 inputColor){
  // Desaturate by Luminosity (ITU-R BT.709, as used by GIMP)
  return 0.21*inputColor.r + 0.72*inputColor.g + 0.07*inputColor.b;
}


vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
  // ${{DESATURATION_METHOD}} gets replaced with a real function name on the
  // lua side before the shader is compiled.
  float grayValue = ${{DESATURATION_METHOD}}(Texel(currentTexture, texCoords));
  return vec4(grayValue, grayValue, grayValue, 1.0);
}
