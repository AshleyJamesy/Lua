function love.load(args)
	hook.Call("love.load", args)
end

function love.update()
	hook.Call("love.update")
end

function love.render()
	hook.Call("love.render")
end

function love.handlers.incoming_message(peer, data)
	hook.Call("incoming_data", peer, data)
	
	local message = json.decode(data)
	if message ~= json.null then
		if message.hook then
			hook.Call(message.hook, peer, unpack(message.data))
		else
			hook.Call("unknown_message", peer, unpack(message.data))
		end
	end
end

function love.handlers.peer_connection(peer, data)
	hook.Call("connection", peer, data)
end

function love.handlers.peer_disconnection(peer, data)
	hook.Call("disconnection", peer, data)
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
	
	collectgarbage()
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

function love.gamepadaxis(joystick, axis, value)
	hook.Call("GamepadAxis", joystick, axis, value)
end

function love.gamepadpressed(joystick, button)
	hook.Call("GamepadPressed", joystick, button)
end

function love.gamepadreleased(joystick, button)
	hook.Call("GamepadReleased", joystick, button)
end

function love.joystickadded(joystick)
	hook.Call("JoystickAdded", joystick)
end

function love.joystickaxis(joystick, axis, value)
	hook.Call("JoystickAxis", joystick, axis, value)
end

function love.joystickhat(joystick, hat, direction)
	hook.Call("JoystickAxis", joystick, hat, direction)
end

function love.joystickpressed(joystick, button)
	hook.Call("JoystickPressed", joystick, button)
end

function love.joystickreleased(joystick, button)
	hook.Call("JoystickReleased", joystick, button)
end

function love.joystickremoved(joystick)
	hook.Call("JoystickRemoved", joystick)
end