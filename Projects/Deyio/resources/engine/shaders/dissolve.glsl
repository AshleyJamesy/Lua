#ifdef VERTEX
	vec4 position(mat4 _, vec4 __)
	{
		return ProjectionMatrix * TransformMatrix * VertexPosition;
	}
#endif

#ifdef PIXEL
	uniform Image u_Emission;
	uniform vec4 u_EmissionColour;
	uniform Image u_Noise;
	
	vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
	{
		vec4 albedo 			= Texel(texture, uv_coords) * colour;
		vec4 emission 			= Texel(u_Emission, uv_coords);
		vec4 noise 				= Texel(u_Noise, uv_coords);

		float opacity 			= 1.0;
		float opacity_cutoff 	= noise.r + u_EmissionColour.a - 0.5;

		vec4 fragColour = vec4(0.0);
		fragColour += vec4(albedo.rgb, 0.0);
		fragColour += vec4(noise.rgb * u_EmissionColour.rgb, 0.0);

		return vec4(fragColour.rgb, step(opacity_cutoff, 0.5) * opacity);
	}
#endif