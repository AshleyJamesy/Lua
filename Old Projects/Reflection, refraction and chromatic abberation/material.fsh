extern Image refractionMap;
extern Image background;
extern Image skymap;
extern Image blend;

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
  vec4 blendFactor = Texel(blend, texCoords.xy);

  // background and geometry may have different aspect ratios; this is the scaling factor geometry -> background
  vec2 scalingFactor = backgroundSize/geometrySize;

  // position of this pixel on the background/skymap if it was directly mapped
  vec2 backgroundPosition = geometryOffset + texCoords/scalingFactor;

  // additional offset into background added by refraction
  vec2 refractionOffset = vec2(2.0*refractionStrength*(offsetVector.x - 0.5)/backgroundSize.x, 
			       2.0*refractionStrength*(offsetVector.y - 0.5)/backgroundSize.y);

  // additional offset into skymap added by reflection
  vec2 reflectionOffset = vec2(2.0*reflectionStrength*(offsetVector.x - 0.5)/backgroundSize.x, 
			       2.0*reflectionStrength*(offsetVector.y - 0.5)/backgroundSize.y);

  // fetch the point from the skymap that was reflected (position + offset)
  vec4 reflectionColor = Texel(skymap, backgroundPosition + reflectionOffset);

  // fetch the point from the background that was refracted (position + offset)
  vec4 refractionColor = vec4(0);
  refractionColor.r = Texel(background, backgroundPosition + refractionOffset*(1 + spectralAbberation)).r;
  refractionColor.g = Texel(background, backgroundPosition + refractionOffset).g;
  refractionColor.b = Texel(background, backgroundPosition + refractionOffset*(1 - spectralAbberation)).b;

  // blend between refraction and reflection
  return (1 - 0.0*blendFactor)*refractionColor + blendFactor*reflectionColor;
}
