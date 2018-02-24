local Class = class.NewClass("GUI")
Class.Index 		= 0
Class.MouseDown 	= false
Class.Active 		= nil
Class.Hovered 		= nil
Class.LastHovered 	= nil
Class.Focused 		= nil
Class.MouseWheel_X 	= 0.0
Class.MouseWheel_Y 	= 0.0
Class.Skins 		= {}
Class.Font 			= love.graphics.newFont(love.window.getPixelScale() * 12.0)

Class.Canvas = love.graphics.newCanvas(Screen.width, Screen.height)

Class.Stack = {
	{
		x 			= 0,
		y 			= 0,
		offset_x 	= { 0 },
		offset_y 	= { 0 },
		width 		= Screen.width,
		height 		= Screen.height,
		vertical 	= { true },
		scissor 	= true
	}
}

function Class:Push(x, y, w, h)
	local rect = {
		x 			= x,
		y 			= y,
		offset_x 	= { 0 },
		offset_y 	= { 0 },
		width 		= w,
		height 		= h,
		vertical 	= { true },
		scissor 	= true
	}

	table.insert(Class.Stack, #Class.Stack + 1, rect)

	return rect
end

function Class:GetRect()
	return GUI.Stack[#GUI.Stack]
end

function Class:Pop()
	table.remove(GUI.Stack, #GUI.Stack, rect)
end

function Class:GetOffset()
	local stack = GUI.Stack[#GUI.Stack]

	return stack.offset_x[#stack.offset_x], 
	stack.offset_y[#stack.offset_y]
end

hook.Add("WindowResize", "GUI", function(w, h)
	Class.Canvas = love.graphics.newCanvas(w, h)
end)

hook.Add("MouseWheelMoved", "GUI", function(x, y)
	Class.MouseWheel_X = x
	Class.MouseWheel_Y = y
end)

function Class:ResetOptions()
	local options = {}
	
	Class.Index = Class.Index + 1
	
	options.id 				= Class.Index	
	options.width 			= 0.0
	options.width_min 		= 0.0
	options.width_max 		= math.huge
	options.width_expand 	= false
	options.height 			= 0.0
	options.height_min 		= 0.0
	options.height_max 		= math.huge
	options.height_expand 	= false
	options.padding_width 	= 0.0
	options.padding_height 	= 0.0
	options.style 			= nil
	options.skin 			= nil

	return options
end

local w = 0.0
local h = 0.0
function Class:GetOptions(style, ...)
	local stack = GUI.Stack[#GUI.Stack]
	local stack_offsetx = stack.offset_x[#stack.offset_x]
	local stack_offsety = stack.offset_y[#stack.offset_y]
	
	local options 	= Class:ResetOptions()
	options.x 		= stack_offsetx
	options.y 		= stack_offsety
	
	if style then
		style:Use(options)
	end
	
	for k, v in pairs({ ... }) do
		v(options)
	end
	
	if options.style then
		options.style:Use(options)
	end

	options.width = 
		options.width_expand and 
		math.clamp(stack.width - stack_offsetx, options.width_min, options.width_max) or 
		math.clamp(options.width, options.width_min, options.width_max)
	
	options.height = 
		options.height_expand and 
		math.clamp(stack.height - stack_offsety, options.height_min, options.height_max) or 
		math.clamp(options.height, options.height_min, options.height_max)
	
	if stack.vertical[#stack.vertical] then
		stack.offset_y[#stack.offset_y] = 
			stack_offsety + options.height + options.padding_height

		if w < options.width + options.padding_width then
			w = options.width + options.padding_width
		end
	else
		stack.offset_x[#stack.offset_x] = 
			stack_offsetx + options.width + options.padding_width

		if h < options.height + options.padding_height then
			h = options.height + options.padding_height
		end
	end
	
	return options.id, stack.x + options.x, stack.y + options.y, options.width, options.height, options
end

function Class:RegisterMouseHit(id, x, y, w, h, capture)
	local mx, my = Screen.Point(love.mouse.getPosition())
	if math.inrange(mx, x, x + w) and math.inrange(my, y, y + h) then
		Class.Hovered = id

		if capture == nil or capture == true then
			if Class.Active == nil and Class.MouseDown then
				Class.Active = id
				return true
			end
		end
	end

	return false
end

function Class:BeginHorizontal()
	local stack = GUI.Stack[#GUI.Stack]

	table.insert(stack.vertical, #stack.vertical + 1, false)
	table.insert(stack.offset_x, #stack.offset_x + 1, stack.offset_x[#stack.offset_x])
	table.insert(stack.offset_y, #stack.offset_y + 1, stack.offset_y[#stack.offset_y])
end

function Class:EndHorizontal()
	local stack = GUI.Stack[#GUI.Stack]

	table.remove(stack.vertical, #stack.vertical)
	table.remove(stack.offset_x, #stack.offset_x)
	table.remove(stack.offset_y, #stack.offset_y)

	stack.offset_y[#stack.offset_y] = stack.offset_y[#stack.offset_y] + h
	h = 0.0
end

function Class:BeginVertical()
	local stack = GUI.Stack[#GUI.Stack]

	table.insert(stack.vertical, #stack.vertical + 1, true)
	table.insert(stack.offset_x, #stack.offset_x + 1, stack.offset_x[#stack.offset_x])
	table.insert(stack.offset_y, #stack.offset_y + 1, stack.offset_y[#stack.offset_y])
end

function Class:EndVertical()
	local stack = GUI.Stack[#GUI.Stack]

	table.remove(stack.vertical, #stack.vertical)
	table.remove(stack.offset_x, #stack.offset_x)
	table.remove(stack.offset_y, #stack.offset_y)
	
	stack.offset_x[#stack.offset_x] = stack.offset_x[#stack.offset_x] + w
	w = 0.0
end

function GUI:Space(amount, ...)
	local stack = GUI.Stack[#GUI.Stack]

	if stack.vertical[#stack.vertical] then
		stack.offset_y[#stack.offset_y] = stack.offset_y[#stack.offset_y] + amount
	else
		stack.offset_x[#stack.offset_x] = stack.offset_x[#stack.offset_x] + amount
	end
end

function Class:RegisterDraw(draw_func, x, y, w, h, options, ...)
	local parameters = { ... }
	local stack = 
		Class.Stack[#Class.Stack]
	
	Class.Canvas:renderTo(function()
		if stack.scissor then
			love.graphics.setScissor(stack.x, stack.y, stack.width, stack.height)
		end

		draw_func(x, y, w, h, options, unpack(parameters))
	end)
end

--[[
function Class:Element(id, options)
	return {
		id 		= id,
		onPress = options.state or false,
		onDown  = id == Class.Active and id == Class.Hovered and Class.MouseDown,
		onClick = id == Class.Active and id == Class.Hovered and not Class.MouseDown,
		onHover = id == Class.Hovered,
		onEnter = id == Class.Hovered and id ~= Class.LastHovered,
		onExit 	= id ~= Class.Hovered and id == Class.LastHovered
	}
end
]]

function Class:Render()
	if not Class.MouseDown then
		Class.Active = nil
	elseif Class.Active == nil then
		Class.Active = -1
	end

	Class.LastHovered, Class.Hovered = Class.Hovered, nil
	Class.Index 			= 0
	Class.MouseDown 		= love.mouse.isDown(1)

	local stack = Class.Stack[#Class.Stack]
	stack.offset_x[1] = 0.0
	stack.offset_y[1] = 0.0

	Class.MouseWheel_X = 0.0
	Class.MouseWheel_Y = 0.0
end

function Class.AddSkin(name, skin)
	GUI.Skins[name] = skin
end

function Class.GetSkin(name)
	return GUI.Skins[name]
end

function Class:Show()
	love.graphics.reset()
	Screen.Draw(Class.Canvas, 0.0, 0.0, 0.0)

	Class.Canvas:renderTo(function()
		love.graphics.clear()
	end)
end