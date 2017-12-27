FFI = require("ffi")

--[[
features = love.graphics.getSupported()
for k, v in pairs(features) do
    print(k,v)
end

limits = love.graphics.getSystemLimits()
for k, v in pairs(limits) do
    print(k, v)
end
]]--

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

graphics = love.graphics

function CallFunctionOnType(typename, method, ...)
	local batch = SceneManager:GetActiveScene().__objects[typename]
	if batch then
		local f = nil

		local index, component = next(batch, nil)
		while index do
			if f == nil then
				f = component[method]

				if f == nil or type(f) ~= "function" then
					f = nil
					break
				end
			end

			if component.enabled == nil or component.enabled == true then
				f(component, ...)
			end

			index, component = next(batch, index)
		end	
	end
end

function CallFunctionOnAll(method, ignore, ...)
	for name, batch in pairs(SceneManager:GetActiveScene().__objects) do
		if ignore == nil then
			CallFunctionOnType(name, method, ...)
		else
			if table.HasValue(ignore, name) then
			else
				CallFunctionOnType(name, method, ...)
			end
		end
	end
end

local hero = Sprite("resources/sprites/hero.png")
hero:NewFrame(16, 16, 16, 16)
hero:NewFrame(32, 16, 16, 16)
hero:NewFrame(48, 16, 16, 16)
hero:NewFrame(64, 16, 16, 16)
hero:NewFrame(80, 16, 16, 16)
hero:NewFrame(96, 16, 16, 16)
hero:NewFrame(16, 32, 16, 16)
hero:NewFrame(32, 32, 16, 16)
hero:NewFrame(48, 32, 16, 16)
hero:NewFrame(64, 32, 16, 16)
hero:NewFrame(80, 32, 16, 16)
hero:NewFrame(96, 32, 16, 16)
hero:NewFrame(16, 48, 16, 16)
hero:NewFrame(32, 48, 16, 16)
hero:NewFrame(48, 48, 16, 16)
hero:NewFrame(64, 48, 16, 16)
hero:NewFrame(96, 48, 16, 16)
hero:NewFrame(16, 64, 16, 16)
hero:NewFrame(32, 64, 16, 16)
hero:NewFrame(48, 64, 16, 16)
hero:NewFrame(64, 64, 16, 16)
hero:NewFrame(80, 64, 16, 16)
hero:NewFrame(96, 64, 16, 16)
hero:NewFrame(16, 80, 16, 16)
hero:NewFrame(32, 80, 16, 16)
hero:NewFrame(48, 80, 16, 16)
hero:NewFrame(64, 80, 16, 16)
hero:NewFrame(80, 80, 16, 16)
hero:NewFrame(96, 80, 16, 16)

hero.pixelPerUnit = 16

hero:NewAnimation("idle", Animation(1.0, true, { 1, 2, 3, 4 }))

local hero_emission = Sprite("resources/sprites/hero_gray.png")

hook.Add("love.load", "game", function()
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()

	local object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")
end)

hook.Add("love.update", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()

	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()

end)

local testCanvas1 = graphics.newCanvas()
local testCanvas2 = graphics.newCanvas()

hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	graphics.draw(Camera.main.canvases.post.source, 0, 0)
	
	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	stats = graphics.getStats()
	stats.fps = love.timer.getFPS()
	stats.memory = string.format("%.2f MB", stats.texturememory / 1024 / 1024)
	stats.x = Application.Mobile
	local t = ""
	for k, v in pairs(stats) do
	    t = t .. k .. ": " .. tostring(v) .. "\n"
	end
	graphics.print(t, 10, 10, 0, 2.5, 2.5)
	
	Input.LateUpdate()
	
	love.graphics.present()
end)