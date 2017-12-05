FFI = require("ffi")

include("extensions/")
include("util/")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

function CallFunctionOnType(typename, method, ...)
	local batch = SceneManager:GetActiveScene().__objects[typename]
	if batch then
		local f = nil
		for _, component in pairs(batch) do
			if f == nil then
				f = component[method]

				if f == nil or type(f) ~= "function" then
					break
				end
			end

			if not component.enabled or component.enabled == true then
				f(component, ...)
			end
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

function love.load(args)
	--hook.Call("Awake")
	--hook.Call("OnEnable")
	--hook.Call("OnLevelWasLoaded")
	
	--hook.Call("Start")

	SceneManager:GetActiveScene()

	local a = GameObject()
	a:AddComponent("Camera").zoom:Set(5, 5)
end

function love.update()
	SceneManager:GetActiveScene().__world:update(Time.Delta)
	
	for k, v in pairs(SceneManager:GetActiveScene().__roots) do
		v:Update()
	end

	CallFunctionOnAll("Update", { "Transform" })
	hook.Call("Update")

	CallFunctionOnAll("LateUpdate")
	hook.Call("LateUpdate")
end

function love.draw()
	CallFunctionOnType("Camera", "Render")
	hook.Call("OnRenderImage") 				--Called after scene rendering is complete to allow post-processing of the image

	love.graphics.draw(Camera.main.texture, 0, 0, 0, 1, 1)

	love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("Body Count: ".. tostring(SceneManager:GetActiveScene().__world:getBodyCount()), 10, 25)
end

function love.directorydropped(path)
	hook.Call("DirectoryDropped", path)
end

function love.filedropped(file)
	hook.Call("FileDropped", file)
end

function love.focus(focus)
	if focus then
		hook.Call("WindowFocus")
	else
		hook.Call("WindowLostFocus")
	end
end

function love.resize(w, h)
	hook.Call("WindowResize", w, h)
end

function love.lowmemory()
	hook.Call("LowMemory")
end

DEBUG = true
function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)

	if key == "space" then
		DEBUG = not DEBUG
	end
end

function love.keyreleased(key, scancode)
	hook.Call("KeyReleased", key, scancode)
end

function love.mousefocus(focus)
	if focus then
		hook.Call("MouseFocus")
	else
		hook.Call("MouseLostFocus")
	end
end

function love.mousepressed(x, y, button, istouch)
	hook.Call("MousePressed", x, y, button, istouch)
	
	if button == 2 then
		local object = GameObject(Camera.main:ScreenToWorld(x, y))
		object:AddComponent("RigidBody").mass = 1000
		object:AddFixture(love.physics.newRectangleShape(0, 0, 50, 50, 0), 1)
		object:AddComponent("Player")
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	hook.Call("MouseMoved", x, y, dx, dy, istouch)
end

function love.mousereleased(x, y, button, istouch)
	hook.Call("MouseReleased", x, y, button, istouch)
end

function love.wheelmoved(x, y)
	hook.Call("MouseWheelMoved", x, y)
end

function love.textedited(text, start, length)
	hook.Call("TextEdited", text, start, length)
end

function love.textinput(char)
	hook.Call("TextInput", char)
end

function love.textedited(text, start, length)
	if length then
		hook.Call("TextEdited", text, start, length)
	end
end

function love.visible(visible)
	hook.Call("WindowVisible", visible)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	hook.Call("TouchPressed", id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end

function love.quit()
	hook.Call("Quit")
end