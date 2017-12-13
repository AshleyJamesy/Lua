includes = {}

if not MOBILE then
	git = ""
else
 log = {}
 function print(o)
     table.insert(log, tostring(o))
	end
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

PixelToUnit = 16
UnitToPixel = 3.0

include("extensions/table")
include("types")
include("class")
include("Time")
include("serialise")
include("json")
include("composition/scene/SceneManager")
include("composition/Asset")

function LoadGame()
 include("composition/GameObject")
 include("composition/components/LineRenderer")
 include("composition/components/Camera")
 include("composition/components/SpriteRenderer")
 include("composition/components/RigidBody")
 include("composition/components/Collider")
 include("composition/components/CircleCollider")
 include("composition/components/Player")
 include("composition/components/Particle")
 include("composition/components/ParticleSystem")

 math.randomseed(os.time())
 
	--love.window.setMode(800, 800, { borderless = true })

	--[[
		modes = love.window.getFullscreenModes()
		table.sort(modes, function(a, b) return a.width *a .height < b.width * b.height end)

		for k, v in pairs(modes) do
			print(k, v.width, v.height, v.width / v.height)
		end
	]]--
	
	myCamera = GameObject()
	myCamera:AddComponent("Camera")
	myCamera:GetComponent("Camera").zoom:Set(1, 1)
	
	myGameObject = GameObject()
	myGameObject:AddComponent("RigidBody")
	myGameObject:AddComponent("SpriteRenderer")
	myGameObject:AddComponent("ParticleSystem")
	myGameObject:GetComponent("ParticleSystem").space = "world"
	myGameObject:AddComponent("Player")
	myGameObject.transform.scale:Set(3, 3)
	
	local a = myGameObject:Serialise()
	print(json.string(a))
	SceneManager.CallFunctionOnAll("SceneLoaded", nil, SceneManager.GetActiveScene())
end

function love.load()
 SceneManager.CreateScene("scene")
 LoadGame()
	--local status, error = pcall(LoadGame)
	--if status then
	--else
	--    print("error: " .. error)
	--end
end

function love.keypressed(key, scancode, isrepeat)
 local status, error = pcall(SceneManager.CallFunctionOnAll, "KeyPressed", nil,  key, scancode, isrepeat)
	if status then    
	else
	    print("error: " .. error)
	end
end

function love.keyreleased(key, scancode)
	SceneManager.CallFunctionOnAll("KeyReleased", nil, key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch)
	SceneManager.CallFunctionOnAll("MouseMoved", nil, x, y, dx, dy, istouch)
end

function love.joystickaxis(joystick, axis, value)
	SceneManager.CallFunctionOnAll("JoystickAxis", nil, joystick, axis, value)
end

function love.mousepressed(x, y, button, istouch)
 local status, error = pcall(SceneManager.CallFunctionOnAll, "MousePressed", nil, x, y, button, istouch)
	if status then
	else
	    print("error: " .. error)
	end
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
	local status, error = pcall(SceneManager.Update, dt)
	if status then
	else
	    print("error: " .. error)
	end
end

function love.draw()
	local status, error = pcall(SceneManager.CallFunctionOnType, "Render", "Camera")
	if status then  
	else
	    print("error: " .. error)
	end
	
	--Editor Draw
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10, 0, 1, 1)

	if MOBILE then
		local s = ""
		for k, v in pairs(log) do
		 s = s .. v .. "\n"
		end

		love.graphics.print("Log:\n" .. s, 10, 35, 0, 2, 2)
	end
end