extern Image refractionMap;
extern Image background;
// extern Image skymap;
// extern Image blend;

extern number refractionStrength;
extern number reflectionStrength;
extern vec2 geometryOffset;
extern vec2 backgroundSize;
extern vec2 geometrySize;

// spectralAbberation determines how strongly the index of refraction differs
// for different wavelengths. A value of zero creates no chromatic abberation,
// a value of 0.1 creates a very strong chromatic abberation.
// Recommended value: 0.02 - 0.04
extern number spectralAbberation;

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords){
  vec4 offsetVector = Texel(refractionMap, texCoords.xy);

  // background and geometry may have different aspect ratios; this is the scaling factor geometry -> background
  vec2 scalingFactor = backgroundSize/geometrySize;

  // position of this pixel on the background/skymap if it was directly mapped
  vec2 backgroundPosition = geometryOffset + texCoords/scalingFactor;

  // additional offset into background added by refraction
  vec2 refractionOffset = vec2(2.0*refractionStrength*(offsetVector.x - 0.5)/backgroundSize.x, 
			       2.0*refractionStrength*(offsetVector.y - 0.5)/backgroundSize.y);

  // get the color from the background
  vec4 refractionColor = Texel(background, backgroundPosition + refractionOffset);

  // blend between refraction and reflection
  return refractionColor;
}
