local Class = class.NewClass("Input")

Class.__mouse 		= {}
Class.__keyboard 	= {}
Class.mousePosition = Vector2(0, 0)
Class.anyKey 		= false
Class.anyKeyDown 	= false

Class.__keyboardCount 	= 0
Class.__mouseCount 		= 0

function Class.GetKey(key)
	return Class.__keyboard[key] ~= nil
end

function Class.GetKeyDown(key)
	return Class.__keyboard[key] == nil and false or Class.__keyboard[key] == Time.Cycle
end

function Class.GetKeyUp(key)
	return Class.__keyboard[key] == nil
end

function Class.GetMouseButton(button)
	return Class.__mouse[button] ~= nil
end

function Class.GetMouseButtonDown(button)
	return Class.__mouse[button] == nil and false or Class.__mouse[button] == Time.Cycle
end

function Class.GetMouseButtonUp(button)
	return Class.__mouse[button] == nil
end

function Class.Update()
	Class.mousePosition:Set(love.mouse.getX(), love.mouse.getY())

	Class.anyKey = Class.__keyboardCount > 0 or Class.__mouseCount > 0
end

function Class.LateUpdate()
	Class.anyKey 		= false
	Class.anyKeyDown 	= false
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
	if not istouch then
		Class.__mouse[button] = Time.Cycle
	else
		Class.__mouse[1] = Time.Cycle
	end

	Class.anyKeyDown 	= true
	Class.__mouseCount 	= Class.__mouseCount + 1
end)

hook.Add("MouseReleased", "Input", function(x, y, button, istouch)
	if not istouch then
		Class.__mouse[button] = nil
	else
		Class.__mouse[1] = nil
	end

	Class.__mouseCount 	= Class.__mouseCount - 1
end)