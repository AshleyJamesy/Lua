FFI = require("ffi")

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

function PrintStats()
	stats 			= graphics.getStats()
	stats.fps 		= love.timer.getFPS()
	stats.memory 	= string.format("%.2f MB", stats.texturememory / 1024 / 1024)

	local text = ""
	for k, v in pairs(stats) do
		text = text .. k .. ": " .. tostring(v) .. "\n"
	end

	graphics.print(text, 10, 10, 0)
end

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

local shader_code = [[
	extern Image texture_cubemap;
	extern Image texture_emission;
	extern Image texture_refraction;
	extern float time;

	float opacity 		= 0.0;

	vec4 base			= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 emission		= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 normal			= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 refraction 	= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 frag_Colour 	= vec4(1.0, 1.0, 1.0, 1.0);
	
	vec4 effect(vec4 colour, Image texture_diffuse, vec2 uv_coords, vec2 screen_coords)
	{
		float sx = (screen_coords.x - 0.5) / 800.0;
		float sy = (screen_coords.y - 0.5) / 600.0;
		
		base = Texel(texture_diffuse, uv_coords.xy);

		vec4 refraction = Texel(texture_refraction, uv_coords.xy);
		refraction 	= Texel(texture_cubemap, vec2(
				sx - (sx * ((refraction.r - 0.5) * 2.0) * 0.01 * 8.0) - 0.00392156862 * 2.0, 
				sy - (sy * ((refraction.b - 0.5) * 2.0) * 0.01 * 8.0) - 0.00392156862 * 2.0
			)
		);
		
		frag_Colour = mix(base, refraction, 1.0 - opacity) * colour;
		
		return frag_Colour;
	}
]]
local shader_source 	= graphics.newShader(shader_code)
local background 		= graphics.newImage("resources/loveforge/background.jpg")
local refraction 		= graphics.newImage("resources/loveforge/refraction.png")
local colour_map 		= graphics.newCanvas()

hook.Add("love.render", "game", function()
	graphics.setCanvas(colour_map)
	graphics.clear(0.0, 0.0, 0.0, 0.0)
	graphics.draw(background)
	graphics.setCanvas()

	graphics.clear(0.0, 0.0, 0.0, 0.0)

	graphics.draw(colour_map)

	graphics.setShader(shader_source)

	shader_source:send("texture_cubemap", colour_map)
	shader_source:send("texture_refraction", refraction)

	graphics.setColor(100, 255, 255, 255)
	graphics.draw(hero.image.source, 666, 182)
	
	graphics.setColor(255, 255, 0, 255)
	graphics.draw(hero.image.source, Input.mousePosition.x, Input.mousePosition.y, 0, 1.0, 1.0, hero.image.width * 0.5, hero.image.height * 0.5)

	graphics.setColor(255, 255, 255, 255)
	graphics.setShader()
end)

--[[
hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	graphics.draw(Camera.main.canvases.post.source, 0, 0)
	
	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	Input.LateUpdate()
	
	PrintStats()
end)
]]