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

function love.load(args)
	--love.window.setFullscreen(true, "exclusive")

    Input.Update()
    Input.LateUpdate()
	--hook.Call("Awake")
	--hook.Call("OnEnable")
	--hook.Call("OnLevelWasLoaded")
	
	--hook.Call("Start")

	SceneManager:GetActiveScene()

	local object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")
end

function love.update()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()

	--[[
	scene.__world:update(Time.Delta)
	
	for k, v in pairs(scene.__inactive) do
		if scene.__objects[v.__typename] == nil then
			scene.__objects[v.__typename] = {}
		end

		table.insert(scene.__objects[v.__typename], 1, v)

		if v.IsMonoBehaviour then
			v:Awake()
			v:Start()
			v:Enable()
		end

		v.enabled = true

		table.remove(scene.__inactive, k)
	end

	for k, v in pairs(scene.__roots) do
		v:Update()
	end

	CallFunctionOnAll("Update", { "Transform" })
	hook.Call("Update")

	CallFunctionOnAll("LateUpdate")
	hook.Call("LateUpdate")
	]]

	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()
	
	Input.LateUpdate()
end

function love.draw()
	local scene = SceneManager:GetActiveScene()

	hook.Call("OnPreRender")

	scene:Render()
	
	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")

	love.graphics.draw(Camera.main.texture.source, 0, 0, 0, 1, 1)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
	love.graphics.print("Count: " .. SceneManager:GetActiveScene():GetCount("SpriteRenderer"), 10, 25)
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

function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)
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
	hook.Call("TouchReleased", id, x, y, dx, dy, pressure)
end

function love.quit()
	hook.Call("Quit")
end