includes = {}
log 	 = {}

if not MOBILE then
	git = ""
else
	function print(string)
		if log[string] then
			log[string].count = log[string].count + 1
		else
			log[string] = {}
			log[string].string = string
			log[string].count  = 1
			log[string].time   = os.time()
		end
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

include("extensions/table")
include("types")
include("class")
include("math")
include("Time")
include("composition/scene/SceneManager")
include("composition/GameObject")
include("composition/components/Camera")
include("composition/components/LineRenderer")
include("composition/components/SpriteRenderer")
include("composition/components/GameManager")
include("composition/components/Player")

function LoadGame()
	math.randomseed(os.time())
	
	myCamera = GameObject()
	myCamera:AddComponent("Camera")
	myCamera:GetComponent("Camera").zoom:Set(1,1)
	myCamera:AddComponent("GameManager")
	
	SceneManager.CallFunctionOnAll("SceneLoaded", nil, SceneManager.GetActiveScene())
end

--[[Joystick and Gamepad]]--
function love.gamepadaxis(joystick, axis, value)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "GamepadAxis", nil,  joystick, axis, value)
	if status then
	else
		print("error: " .. error)
	end
end

function love.gamepadpressed(joystick, button)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "GamepadPressed", nil,  joystick, button)
	if status then
	else
		print("error: " .. error)
	end
end

function love.gamepadreleased(joystick, button)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "GamepadReleased", nil,  joystick, button)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickadded(joystick)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickAdded", nil,  joystick)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickaxis(joystick, axis, value)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickAxis", nil,  joystick, axis, value)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickhat(joystick, hat, direction)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickHat", nil,  joystick, hat, direction)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickpressed(joystick, button)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickPressed", nil,  joystick, button)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickreleased(joystick, button)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickReleased", nil,  joystick, button)
	if status then
	else
		print("error: " .. error)
	end
end

function love.joystickremoved(joystick)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "JoystickRemoved", nil,  joystick)
	if status then
	else
		print("error: " .. error)
	end
end

--[[Keyboard]]--
function love.keypressed(key, scancode, isrepeat)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "KeyPressed", nil,  key, scancode, isrepeat)
	if status then
	else
		print("error: " .. error)
	end
end

function love.keyreleased(key, scancode)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "KeyReleased", nil,  key, scancode)
	if status then
	else
		print("error: " .. error)
	end
end

--[[Mouse]]--
function love.mousemoved(x, y, dx, dy, istouch)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "MouseMoved", nil, x, y, dx, dy, istouch)
	if status then
	else
		print("error: " .. error)
	end
end

function love.mousepressed(x, y, button, istouch)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "MousePressed", nil, x, y, button, istouch)
	if status then
	else
		print("error: " .. error)
	end
end

function love.mousereleased(x, y, button, istouch)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "MouseReleased", nil, x, y, button, istouch)
	if status then
	else
		print("error: " .. error)
	end
end

function love.wheelmoved(x, y)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "ScrollWheelMoved", nil, x, y)
	if status then
	else
		print("error: " .. error)
	end
end

--[[Window]]--
function love.resize(w, h)
	local status, error = pcall(SceneManager.CallFunctionOnAll, "WindowResize", w, h, love.window.getFullscreen())
	if status then
	else
		print("error: " .. error)
	end
end

--[[Game]]--
function love.load()
	SceneManager.CreateScene("scene")
	
	local status, error = pcall(LoadGame)
	if status then
	else
		print("error: " .. error)
	end
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
	
	status, error = pcall(SceneManager.CallFunctionOnType, "Gizmos", "Camera")
	if status then  
	else
		print("error: " .. error)
	end

	--Editor Draw
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

	if MOBILE then
		local s = ""
		for k, v in pairs(log) do
			s = s .. v.string .. " | " .. v.count .. " | " .. v.time .. "\n"
		end
		
		love.graphics.print("Log:\n" .. s, 10, 20, 0, 2, 2)
	end
end