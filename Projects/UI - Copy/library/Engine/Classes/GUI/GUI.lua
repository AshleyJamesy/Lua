local GUI = class.NewClass("GUI")
GUI.Index 			= 0
GUI.Active 			= nil
GUI.Hovered 		= nil
GUI.LastHovered 	= nil
GUI.FocusForward 	= true
GUI.Focused 		= nil
GUI.LastFocused 	= nil
GUI.Overlay 		= nil
GUI.Cursor 			= 0
GUI.Key 			= nil
GUI.KeyPressed 		= nil
GUI.Font 			= love.graphics.newFont(12.0)
GUI.Canvas 			= love.graphics.newCanvas(Screen.width, Screen.height)

GUI.Stack = {
	{
		x 				= 0.0,
		y 				= 0.0,
		offsetx 		= 0.0,
		offsety 		= 0.0,
		width 			= Screen.width,
		height 			= Screen.height,
		vertical 		= { true },
		vertical_space 	= { 0.0 },
		scissor 		= true
	}
}

love.keyboard.setKeyRepeat(true)

hook.Add("WindowResize", "GUI", function(w, h)
	GUI.Canvas = love.graphics.newCanvas(w, h)
end)

hook.Add("KeyPressed", "GUI", function(key)
	GUI.KeyPressed = key
end)

hook.Add("TextInput", "GUI", function(char)
	GUI.Key = char
end)

function GUI:SetFocus(id)
	if id ~= GUI.Focused then
		GUI.LastFocused = GUI.Focused
		GUI.Focused 	= id
	end
end

function GUI:NextFocus(id, forward)
	if GUI.Focused ~= nil then
		if GUI.Focused == id then
			if forward ~= nil then
				GUI.FocusForward = forward
			end
			
			GUI.LastFocused 	= GUI.Focused
			GUI.Focused 		= GUI.Focused + (GUI.FocusForward and 1 or -1)
		end
	end
end

function GUI:GetFocus(id)
	return GUI.Focused == id
end

function GUI:CaptureKey(key)
	if GUI.KeyPressed == key then
		GUI.KeyPressed = nil

		return true
	end
	
	return false
end

function GUI:AnyKey()
	return (GUI.Key ~= nil) or (GUI.KeyPressed ~= nil)
end

function GUI:MoveCursor(amount, max)
	GUI.Cursor 				= math.clamp(GUI.Cursor + amount, 0, max or math.huge)
	GUI.CursorVisible 		= true
	GUI.CursorBlinkTimer 	= 0.8
end

function GUI:GetCursorPosition()
	return GUI.Cursor
end

function GUI:SetCursor(index, max)
	GUI.Cursor 				= math.clamp(index, 0, max or math.huge)
	GUI.CursorVisible 		= true
	GUI.CursorBlinkTimer 	= 0.8
end

function GUI:Push(x, y, w, h)
	local rect = {
		x 				= x,
		y 				= y,
		offsetx 		= 0.0,
		offsety 		= 0.0,
		width 			= w,
		height 			= h,
		vertical 		= { true },
		vertical_space 	= { 0.0 },
		scissor 		= true
	}
	
	table.insert(GUI.Stack, 1, rect)
	
	return rect
end

function GUI:Pop()
	local rect = GUI.Stack[1]
	
	table.remove(GUI.Stack, 1)
	
	return rect
end

function GUI:ResetOptions()
	local options = {}
	
	GUI.Index = GUI.Index + 1
	
	options.id 				= GUI.Index
	options.x 				= 0.0
	options.y 				= 0.0
	options.width 			= 0.0
	options.width_min 		= 0.0
	options.width_max 		= math.huge
	options.width_expand 	= false
	options.height 			= 0.0
	options.height_min 		= 0.0
	options.height_max 		= math.huge
	options.height_expand 	= false
	options.padding_width 	= 1.0
	options.padding_height 	= 1.0
	
	return options
end

function GUI:GetOptions(...)
	local rect 			= GUI.Stack[1]
	local options 		= GUI:ResetOptions()

	for k, v in pairs({ ... }) do
		v(options)
	end
	
	options.x = rect.x + rect.offsetx
	options.y = rect.y + rect.offsety

	options.width = 
		(options.width_expand and 
		math.clamp(rect.width - rect.offsetx, options.width_min, options.width_max) or 
		math.clamp(options.width, options.width_min, options.width_max))
	
	options.height = 
		(options.height_expand and 
		math.clamp(rect.height - rect.offsety, options.height_min, options.height_max) or 
		math.clamp(options.height, options.height_min, options.height_max))

	if rect.vertical[1] then
		rect.offsety = 
			rect.offsety + options.height + options.padding_height
	else
		rect.offsetx = 
			rect.offsetx + options.width + options.padding_width

		if rect.vertical_space[1] < options.height + options.padding_height then
			rect.vertical_space[1] = options.height + options.padding_height
		end
	end

	if math.inrange(Input.mousePosition.x, rect.x, rect.x + rect.width) and math.inrange(Input.mousePosition.y, rect.y, rect.y + rect.height) then
		if math.inrange(Input.mousePosition.x, options.x, options.x + options.width) and math.inrange(Input.mousePosition.y, options.y, options.y + options.height) then
			GUI.Hovered = options.id
		end
	end

	return options.id, options.x, options.y, options.width, options.height, options
end

function GUI:RegisterMouseHit(id, x, y, w, h)
	local rect = GUI.Stack[1]
	
	if math.inrange(Input.mousePosition.x, rect.x, rect.x + rect.width) and math.inrange(Input.mousePosition.y, rect.y, rect.y + rect.height) then
		if math.inrange(Input.mousePosition.x, x, x + w) and math.inrange(Input.mousePosition.y, y, y + h) then
			if Input.GetMouseButtonDown(1) then
				GUI.Active = id
			end
		end
	end
end

function GUI:RegisterDraw(draw_func, x, y, w, h, options, ...)
	local rect 			= GUI.Stack[1]
	local parameters 	= { ... }
	
	GUI.Canvas:renderTo(function()
		if rect.scissor then
			love.graphics.setScissor(rect.x, rect.y, rect.width, rect.height)
		else
			love.graphics.setScissor()
		end
		
		draw_func(x, y, w, h, options, unpack(parameters))
		
		love.graphics.setScissor()
	end)
end

function GUI:BeginHorizontal()
	local rect = GUI.Stack[1]

	table.insert(rect.vertical, 1, false)
	table.insert(rect.vertical_space, 1, 0.0)
end

function GUI:EndHorizontal()
	local rect = GUI.Stack[1]

	table.remove(rect.vertical, 1)

	local rect 			= GUI.Stack[1]
	rect.offsetx 		= 0.0
	rect.offsety 		= rect.offsety + rect.vertical_space[1]

	table.remove(rect.vertical_space, 1)
end

function GUI:BeginVertical()
	local rect = GUI.Stack[1]
	table.insert(rect.vertical, 1, true)
end

function GUI:EndVertical()
	local rect = GUI.Stack[1]
	table.remove(rect.vertical, 1)
end

function GUI:Space(amount, ...)
	local stack = GUI.Stack[1]
	
	if stack.vertical[1] then
		stack.offsety = stack.offsety + amount
	else
		stack.offsetx = stack.offsetx + amount
	end
end

function GUI:GetActive(id)
	return id == GUI.Active
end

function GUI:MousePressed(id)
	return id == GUI.Active and id == GUI.Hovered and Input.GetMouseButtonDown(1, Time.Cycle - 1)
end

function GUI:MouseReleased(id)
	return id == GUI.Active and id == GUI.Hovered and Input.GetMouseButtonUp(1)
end

function GUI:MouseDown(id)
	return id == GUI.Active and id == GUI.Hovered
end

GUI.CursorVisible 		= false
GUI.CursorBlinkTimer 	= 0.8
function GUI:Render()
	if GUI.Overlay then
		GUI.Overlay()
		GUI.Overlay = nil
	end

	if Input.GetMouseButtonUp(1) then
		if GUI.Active ~= nil then
			GUI.Active = nil
		end
	end

	local rect = GUI.Stack[1]
	rect.offsetx 		= 0.0
	rect.offsety 		= 0.0
	rect.width 			= Screen.width
	rect.height 		= Screen.height

	GUI.LastHovered 	= GUI.Hovered
	GUI.Hovered 		= nil
	GUI.Index 			= 0
	GUI.Key 			= nil
	GUI.KeyPressed 		= nil

	GUI.CursorBlinkTimer = GUI.CursorBlinkTimer - Time.Delta

	if GUI.CursorBlinkTimer < 0.0 then
		GUI.CursorBlinkTimer = 0.8
		GUI.CursorVisible = not GUI.CursorVisible
	end
end

function GUI:Show()
	love.graphics.reset()
	Screen.Draw(GUI.Canvas, 0.0, 0.0, 0.0)

	GUI.Canvas:renderTo(function()
		love.graphics.clear()
	end)
end