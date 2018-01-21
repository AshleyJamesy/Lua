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
	Shader("resources/engine/shaders/default.glsl")
	Shader("resources/engine/shaders/dissolve.glsl")
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

	Material("Sprite/Dissolve", "resources/engine/shaders/dissolve.glsl")
	Material("Sprite/Dissolve"):Set("u_Noise", Image("resources/noise.png").source)
	Material("Sprite/Dissolve"):Set("u_Emission", Image("resources/emission_01.png").source)
	Material("Sprite/Dissolve"):Set("u_EmissionColour", { 1.0, 0.0, 0.0, 0.0 })
	
	Material("Sprite/Default", "Default")
	
	Sprite("resources/grass.png")
	Sprite("resources/grass.png"):NewFrame(0, 0, 32, 32)
	Sprite("resources/grass.png"):NewFrame(32, 0, 32, 32)
	Sprite("resources/grass.png"):NewFrame(64, 0, 32, 32)

	Sprite("resources/male.png")
	Sprite("resources/male.png"):NewFrame(0  , 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(64 , 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(128, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(192, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(256, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(320, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(384, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(448, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(512, 0, 64, 128)
	Sprite("resources/male.png"):NewFrame(576, 0, 64, 128)

	Sprite("resources/male.png"):NewAnimation("idle", Animation(0.5, true, { 1, 2 }))
	Sprite("resources/male.png"):NewAnimation("blink", Animation(1.0, false, { 3 }))
	Sprite("resources/male.png"):NewAnimation("run", Animation(7.0, true, { 4, 5, 6, 7, 8, 9, 10 }))

	hook.Call("Initalise")
	
	--Screen.Flip()
 	
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()
	
	object = GameObject()
	object:AddComponent("Camera")

	local cam = object:GetComponent("Camera")
	cam.backgroundColour:Set(130, 200, 110, 255)

	object:AddComponent("SpriteRenderer")
	object:AddComponent("Move")

	local sr 		= object:GetComponent("SpriteRenderer")
	sr.sprite 		= Sprite("resources/male.png")
	sr:PlayAnimation("run")

	for i = 1, 20 do
		object = GameObject()
		object.layer = -2
		object:AddComponent("SpriteRenderer")
		
		object.transform.position:Set(math.random() * 1000 - 500, math.random() * 1000 - 500)
		
		local sr 	= object:GetComponent("SpriteRenderer")
		sr.sprite 	= Sprite("resources/grass.png")
		sr.colour:Set(50, 200, 50, 255)
		sr.index = math.floor((math.random() * 3))
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
	
	--Screen.Print(table.ToString(stats), 10, 10, 1.0, 1.0)
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