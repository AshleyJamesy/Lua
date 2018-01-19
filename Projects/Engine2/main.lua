FFI = require("ffi")
BIT = require("bit")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

stats     = {}
graphics  = love.graphics

--TODO:
--[[
		deffered rendering
		material batching
]]

hook.Add("love.load", "game", function()
	Shader("Sprite/Dissolve", [[
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
        vec4 albedo   = Texel(texture, uv_coords) * colour;
        vec4 emission = Texel(u_Emission, uv_coords);
        vec4 noise    = Texel(u_Noise, uv_coords);
        
        float opacity         = 1.0;
        float opacity_cutoff  = noise.r + u_EmissionColour.a - 0.5;
        
        vec4 fragColour = vec4(0.0);
        fragColour += vec4(albedo.rgb, 0.0);
        fragColour += vec4(noise.rgb * u_EmissionColour.rgb, 0.0);
        
        return vec4(fragColour.rgb, step(opacity_cutoff, 0.5) * opacity);
				}
			#endif
		]])
		
	Material("Sprite/Dissolve", "Sprite/Dissolve")
	Material("Sprite/Dissolve"):Set("u_Noise", Image("resources/noise.png").source)
	Material("Sprite/Dissolve"):Set("u_Emission", Image("resources/emission_01.png").source)
	Material("Sprite/Dissolve"):Set("u_EmissionColour", { 1.0, 0.0, 0.0, 0.0 })
	
	Shader("Sprite/Default", [[
	    #ifdef VERTEX
				vec4 position(mat4 _, vec4 __)
				{
        return ProjectionMatrix * TransformMatrix * VertexPosition;
				}
			#endif

			#ifdef PIXEL
			 uniform Image u_Emission;
			 uniform vec4 u_EmissionColour;
			 
				vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
				{
        vec4 albedo   = Texel(texture, uv_coords) * colour;
        vec4 emission = Texel(u_Emission, uv_coords);
        
        float opacity         = 1.0;
        float opacity_cutoff  = 0.0;
        
        vec4 fragColour = vec4(0.0);
        fragColour += vec4(albedo.rgb, 0.0);
        fragColour += vec4(emission.rgb * u_EmissionColour.rgb * u_EmissionColour.a, 0.0);
        
        return vec4(fragColour.rgb, step(opacity_cutoff, 0.5) * opacity);
				}
			#endif
	]])
	
	Shader("Default", [[
			#ifdef VERTEX
				vec4 position(mat4 _, vec4 __)
				{
					return ProjectionMatrix * TransformMatrix * VertexPosition;
				}
			#endif

			#ifdef PIXEL
				vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
				{
					return Texel(texture, uv_coords) * colour;
				}
			#endif
	]])
	Material("Sprite/Default", "Default")
	
	hook.Call("Initalise")
	
	Screen.Flip()
 
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()
	
	object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")
 
	for i = 1, 100 do
		local object = GameObject()
		object:AddComponent("SpriteRenderer").sprite = Sprite("resources/floor.png")
	end
end)

hook.Add("love.update", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()
 
	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()
end)

hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	Screen.Draw(Camera.main.buffers.post.source, 0, 0, 0)

	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	Input.LateUpdate()
	
	Screen.Print(table.ToString(stats), 10, 10, 1.0, 1.0)
end)

hook.Add("OnRenderImage", "debug", function()
	stats.graphics 					= graphics.getStats()
	stats.graphics.memory 			= string.format("%.2f MB", stats.graphics.texturememory / 1024 / 1024)
	stats.graphics.texturememory 	= nil
	stats.fps 						= love.timer.getFPS()
	stats.mouse 					= Vector2(Input.GetMousePosition())
	stats.screen 					= Vector2(Screen.width, Screen.height)
	stats.camera 					= Camera.main.transform.globalPosition
end)