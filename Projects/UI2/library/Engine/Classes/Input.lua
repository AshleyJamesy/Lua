local Class = class.NewClass("Input")

Class.__mouse 		= {}
Class.__keyboard 	= {}
Class.__touch 		= {}
Class.mousePosition = Vector2(0, 0)
Class.mouseDelta = Vector2(0, 0)
Class.mouseWheel 	= Vector2(0, 0)
Class.anyKey 		= false
Class.anyKeyDown 	= false

Class.__joysticks = {}

Class.__keyboardCount 	= 0
Class.__mouseCount 		= 0
Class.__touchCount 		= 0

Class.acceleration = { x = 0, y = 0, z = 0 }

function Class.GetKey(key)
	return Class.__keyboard[key] ~= nil
end

function Class.GetKeyDown(key, cycle)
	return Class.__keyboard[key] == nil and false or Class.__keyboard[key] == (cycle or Time.Cycle)
end

function Class.GetKeyUp(key)
	return Class.__keyboard[key] == nil
end

function Class.GetMouseButton(button)
	return Class.__mouse[button] ~= nil or Class.GetTouch(button)
end

function Class.GetMouseButtonDown(button, cycle)
	return Class.__mouse[button] == nil and Class.GetTouchDown(button) or Class.__mouse[button] == (cycle or Time.Cycle)
end

function Class.GetMouseButtonUp(button)
	return Class.__mouse[button] == nil
end

--function Class.CaptureMouseEvent(button)
--	if Class.__mouse[button] then
--		Class.__mouse[button] = nil
--		Class.__mouseCount = Class.__mouseCount - 1
--	end
--end

function Class.GetMousePosition()
	return Class.mousePosition.x, Class.mousePosition.y
end

function Class.GetMouseWheel()
	return Class.mouseWheel.x, Class.mouseWheel.y
end

function Class.GetTouch(id)
	return Class.__touch[id] ~= nil and (Class.__touch[id].state == "Pressed" or Class.__touch[id].state == "Down" or Class.__touch[id].state == "Moved") or false
end

function Class.GetTouchDown(id)
	return Class.__touch[id] ~= nil and Class.__touch[id].state == "Pressed"
end

function Class.GetTouchUp(id)
	return Class.__touch[id] ~= nil and (Class.__touch[id].state == "Released" or Class.__touch[id].state == "Up") or false
end

function Class.GetTouchStatus(id)
	return Class.__touch[id] ~= nil and Class.__touch[id].state or "Up"
end

function Class.GetTouchMoved(id)
	return Class.__touch[id] ~= nil and Class.__touch[id].state == "Moved"
end

function Class.GetTouchPosition(id)
	local touch = Class.__touch[id]
	if touch ~= nil then
		return touch.position.x, touch.position.y
	end
	
	return 0, 0
end

function Class.GetAxis(id, direction)
	local joystick = Class.__joysticks[id]
	
	if joystick then
		if joystick.axis[direction] then
			return joystick.axis[direction]
		end
	end
	
	return 0
end

function Class.GetJoystickButton(joystick, button)
	return Class.__joysticks[joystick].buttons[button] ~= nil
end

function Class.GetJoystickButtonDown(joystick, button, cycle)
	return Class.__joysticks[joystick].buttons[button] == nil and false or Class.__joysticks[joystick].buttons[button] == (cycle or Time.Cycle)
end

function Class.GetJoystickButtonUp(joystick, button)
	return Class.__joysticks[joystick].buttons[button] == nil
end


local joystick = love.joystick.getJoysticks()[1]
function Class.Update()
	local x, y = Screen.Point(love.mouse.getX(), love.mouse.getY())

	Class.anyKey = Class.__keyboardCount > 0 or Class.__mouseCount > 0 or Class.__touchCount > 0
 
	if Application.Mobile then
		if Class.GetTouch(1) then
			Class.mousePosition:Set(x, y)
		end
		
		Class.acceleration.x = joystick:getAxis(1)
		Class.acceleration.y = joystick:getAxis(2)
		Class.acceleration.z = joystick:getAxis(3)
	else
		Class.mousePosition:Set(x, y)
	end
end

function Class.LateUpdate()
	Class.anyKey     = false
	Class.anyKeyDown = false
	
	for k, v in pairs(Class.__touch) do
		if v.state == "Pressed" then
			v.state = "Down"
			
			Class.__touchCount = Class.__touchCount + 1
		end
		
		if v.state == "Moved" then
			v.state = "Down"
		end
		
		if v.state == "Released" then
			v.state = "Up"
			
			Class.__touchCount = Class.__touchCount - 1
		end
	end

	Class.mousePosition:Set(0, 0)
	Class.mouseDelta:Set(0, 0)
	Class.mouseWheel:Set(0, 0)
end

hook.Add("KeyPressed", "Input", function(key, scancode, isrepeat)
	Class.__keyboard[key] 	= Time.Cycle
	
	Class.anyKeyDown 		= true
	Class.__keyboardCount 	= Class.__keyboardCount + 1
end)

hook.Add("KeyReleased", "Input", function(key, scancode)
	Class.__keyboard[key] = nil

	Class.__keyboardCount = Class.__keyboardCount - 1
end)

hook.Add("MousePressed", "Input", function(x, y, button, istouch)
		Class.__mouse[button] = Time.Cycle
		
		Class.anyKeyDown 	= true
		Class.__mouseCount 	= Class.__mouseCount + 1
end)

hook.Add("MouseReleased", "Input", function(x, y, button, istouch)
		Class.__mouse[button] = nil
		Class.__mouseCount 	= Class.__mouseCount - 1
end)


hook.Add("MouseMoved", "Input", function(x, y, dx, dy, istouch)
	if Screen.flipped then
	    Class.mouseDelta:Set(dy, dx)
	else
	    Class.mouseDelta:Set(dx, dy)
	end
end)

hook.Add("TouchPressed", "Input", function(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end
	
	Class.__touch[uid] = {
		id        = uid,
		state     = "Pressed",
		touch     = id,
		position  = Vector2(Screen.Point(x, y)),
		delta     = Vector2(dx,dy)
	}
	
	Class.anyKeyDown = true
end)

hook.Add("TouchMoved", "Input", function(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end
	
	local touch = Class.__touch[uid]
	
	touch.state = "Moved"
	touch.id    = uid
	touch.touch = id
	touch.position:Set(Screen.Point(x, y))
	touch.delta:Set(dx, dy)
end)

hook.Add("TouchReleased", "Input", function(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end
	
	local touch = Class.__touch[uid]
	
	touch.state = "Released"
	touch.id    = uid
	touch.touch = nil
	touch.position:Set(Screen.Point(x, y))
	touch.delta:Set(dx, dy)
end)

hook.Add("MouseWheelMoved", "Input", function(x, y)
	Class.mouseWheel:Set(x, y)
end)

hook.Add("JoystickAdded", "Input", function(joystick)
	if Class.__joysticks[joystick] == nil then
		Class.__joysticks[joystick]         = {}
		Class.__joysticks[joystick].axis    = {}
		Class.__joysticks[joystick].buttons = {}
	end
end)

hook.Add("GamepadPressed", "Input", function(joystick, button)
	Class.__joysticks[joystick].buttons[button] = Time.Cycle
end)

hook.Add("GamepadReleased", "Input", function(joystick, button)
	Class.__joysticks[joystick].buttons[button] = nil
end)

hook.Add("JoystickAxis", "Input", function(joystick, axis, value)
	if Class.__joysticks[joystick] then
	    Class.__joysticks[joystick].axis[axis] = value
 end
end)

