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
	if Application.Mobile then
	else
		include("steamworks")
	end
	
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()

	local object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")

	steamid = steamworks.user.GetSteamID()
	user 	= steamworks.GetFriendObjectFromSteamID(steamid)

	if steamworks then
		local image = user:GetMediumAvatar()

		local love_image = love.image.newImageData(64, 64)
		steamworks.utils.GetImageRGBA(image, love_image:getPointer(), love_image:getSize())

		steam_image = love.graphics.newImage(love_image)
	end

	ui = love.graphics.newCanvas()
end)

hook.Add("love.update", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()

	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()

end)

local ripple = Shader("resources/shaders/ripple.glsl")

local text = love.graphics.newImage("resources/love-big-ball.png")

Menu = false
hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	if Menu then
		love.graphics.setCanvas(ui)
		love.graphics.clear(0,0,0,0)

		--blur(Camera.main.canvases.post.source, 3, 3, 5, 1.0)
		--ripple:Use()
		--ripple:Send("screen", Screen.Dimensions)
		--ripple:Send("time", Time.Elapsed)

		love.graphics.draw(text, 400, 400, 0, 1, 1)

		--ripple:Default()

		love.graphics.setCanvas()
		love.graphics.draw(ui, 0, 0, 0, 1, 1)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
		love.graphics.print("Count: " .. SceneManager:GetActiveScene():GetCount("SpriteRenderer"), 10, 25)
		love.graphics.print("Steam Name: " .. user:GetPersonaName(), 10, 40)

		if steamworks then
			love.graphics.draw(steam_image, 10, 60, 0, 1, 1)
		end
	else
		love.graphics.draw(Camera.main.canvases.post.source, 0, 0, 0, 1, 1)
	end

	Input.LateUpdate()
end)