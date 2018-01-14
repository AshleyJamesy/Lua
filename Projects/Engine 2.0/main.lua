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
	hook.Call("Initalise")
	
	Shader("agga", [[
		agagadg
	]])

	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()
	
	object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")

	for i = 1, 10 do
		object = GameObject()
		object:AddComponent("SpriteRenderer")
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

--[[
local sh = Shader("resources/shaders/atlas.glsl")
local ia = Image("resources/tan_bricks.png")
local ib = Image("resources/floor.png")

hook.Add("love.render", "game", function()
	sh:Use()
	
	for i = 1, 10000 do
		sh:Send("rows", 	2.0)
		sh:Send("columns", 	2.0)
		sh:Send("index", 	0.0)
		graphics.draw(ia.source, Screen.center.x, Screen.center.y, 0, (100 / ia.width), (100 / ia.height), ia.halfWidth, ia.halfHeight)
	end
	
	Shader:Reset()

	hook.Call("OnRenderImage")
	
	Screen.Print(table.ToString(stats), 10, 10, 1.0, 1.0)
end)
]]

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