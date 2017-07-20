includes = {}

if not MOBILE then
	git = ""
end

function GetProjectDirectory()
	return git 
end

function include(file)
	local include_path	= string.gsub(GetProjectDirectory(), "/", ".")
	local file_path		= string.gsub(file, "/", ".")
	local full_path		= include_path .. file_path
	
	if includes[full_path] then 
		return
	end

	includes[full_path] = true

	local file = require(full_path)

	return file
end

include("extensions/table")
include("types")
include("class")
include("Time")
include("composition/scene/SceneManager")
include("composition/GameObject")
include("composition/components/LineRenderer")
include("composition/components/Camera")

function love.load()
	math.randomseed(os.time())
	SceneManager.CreateScene("scene")
	
	--love.window.setMode(800, 800, { borderless = true })

	--[[
		modes = love.window.getFullscreenModes()
		table.sort(modes, function(a, b) return a.width *a .height < b.width * b.height end)

		for k, v in pairs(modes) do
			print(k, v.width, v.height, v.width / v.height)
		end
	]]
	
	myCamera = GameObject()
	myCamera:AddComponent("Camera")
	myCamera:GetComponent("Camera").zoom:Set(1,1)
	--myCamera:GetComponent("Camera").culling = { "Default" }

	for i = 1, 1000 do
		local myObject = GameObject()
		myObject:AddComponent("LineRenderer")
		myObject:GetComponent("LineRenderer").colour:Set(math.random() * 255, math.random() * 255, math.random() * 255, 255)
		myObject.transform.position:Set(0,0)
		myObject.layer = 0
	end
	
	SceneManager.CallFunctionOnAll("SceneLoaded", nil, SceneManager.GetActiveScene())
end

function love.keypressed(key, scancode, isrepeat)
	SceneManager.CallFunctionOnAll("KeyPressed", nil,  key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	SceneManager.CallFunctionOnAll("KeyReleased", nil, key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch)
	SceneManager.CallFunctionOnAll("MouseMoved", nil, x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch)
	SceneManager.CallFunctionOnAll("MousePressed", nil, x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	SceneManager.CallFunctionOnAll("MouseReleased", nil, x, y, button, istouch)
end

function love.wheelmoved(x, y)
	SceneManager.CallFunctionOnAll("ScrollWheelMoved", nil, x, y)
end

function love.resize(w, h)
	SceneManager.CallFunctionOnAll("WindowResize", nil, w, h, love.window.getFullscreen())
end

function love.update(dt)
	SceneManager.Update(dt)
end

function love.draw()
	SceneManager.CallFunctionOnType("Render", "Camera")
	
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end