local GUI = class.NewClass("GUI")
GUI.Index 			= 0
GUI.MouseDown 		= false
GUI.Active 			= nil
GUI.Hovered 		= nil
GUI.LastHovered 	= nil
GUI.Focused 		= nil
GUI.LastFocused 	= nil
GUI.OnFocused 		= nil
GUI.MouseX 			= 0.0
GUI.MouseY 			= 0.0
GUI.MouseWheel_X 	= 0.0
GUI.MouseWheel_Y 	= 0.0
GUI.Key 			= nil
GUI.Cursor 			= 0
GUI.KeyPressed 		= nil
GUI.Skins 			= {}
GUI.PixelScale 		= love.window.getPixelScale()
GUI.Canvas 			= love.graphics.newCanvas(Screen.width, Screen.height)
GUI.Font 			= love.graphics.newFont(12.0 * GUI.PixelScale)

GUI.Stack = {
	{
		x 			= 0.0,
		y 			= 0.0,
		offsetx 	= 0.0,
		offsety 	= 0.0,
		max_width 	= 0.0,
		max_height 	= 0.0,
		width 		= Screen.width * GUI.PixelScale,
		height 		= Screen.height * GUI.PixelScale,
		vertical 	= true,
		scissor 	= true
	}
}

love.keyboard.setKeyRepeat(true)

hook.Add("WindowResize", "GUI", function(w, h)
	GUI.Canvas = love.graphics.newCanvas(w, h)
end)

hook.Add("MouseWheelMoved", "GUI", function(x, y)
	GUI.MouseWheel_X = x
	GUI.MouseWheel_Y = y
end)

hook.Add("KeyPressed", "GUI", function(key)
	GUI.KeyPressed = key
end)

hook.Add("TextInput", "GUI", function(char)
	GUI.Key = char
end)

function GUI:SetFocus(id)
	if id ~= GUI.Focused then
		GUI.LastFocused 	= GUI.Focused
		GUI.Focused 		= id
	end
end

function GUI:NextFocus(id)
	if GUI.Focused ~= nil then
		if GUI.Focused == id then
			GUI.LastFocused 	= GUI.Focused
			GUI.Focused 		= GUI.Focused + 1
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
	return GUI.KeyPressed ~= nil
end

function GUI:Push(x, y, w, h)
	local rect = {
		x 			= x,
		y 			= y,
		offsetx 	= 0.0,
		offsety 	= 0.0,
		max_width 	= 0.0,
		max_height 	= 0.0,
		width 		= w,
		height 		= h,
		vertical 	= true,
		scissor 	= true
	}
	
	table.insert(GUI.Stack, 1, rect)
	
	return rect
end

function GUI:Pop()
	local stack = GUI.Stack[1]
	
	table.remove(GUI.Stack, 1)

	return stack
end

function GUI:ResetOptions()
	local options = {}
	
	GUI.Index = GUI.Index + 1
	
	options.id 				= GUI.Index	
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

local verticals = { 
	true 
}

function GUI:GetOptions(style, ...)
	local stack 		= GUI.Stack[1]
	local stack_offsetx = stack.offsetx
	local stack_offsety = stack.offsety
	
	local options 	= GUI:ResetOptions()
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
		(options.width_expand and 
		math.clamp(stack.width - stack_offsetx, options.width_min, options.width_max) or 
		math.clamp(options.width, options.width_min, options.width_max)) * GUI.PixelScale
	
	options.height = 
		(options.height_expand and 
		math.clamp(stack.height - stack_offsety, options.height_min, options.height_max) or 
		math.clamp(options.height, options.height_min, options.height_max)) * GUI.PixelScale
	
	if stack.vertical then
		stack.offsety = 
			stack_offsety + options.height + options.padding_height * GUI.PixelScale

		stack.max_width = math.max(stack.max_width,  options.width + options.padding_width * GUI.PixelScale)
	else
		stack.offsetx = 
			stack_offsetx + options.width + options.padding_width * GUI.PixelScale

		stack.max_height = math.max(stack.max_height,  options.height + options.padding_height * GUI.PixelScale)
	end

	return options.id, stack.x + options.x, stack.y + options.y, options.width, options.height, options
end

function GUI:RegisterMouseHit(id, x, y, w, h, capture)
	local stack = GUI.Stack[1]
	
	if math.inrange(GUI.MouseX, stack.x, stack.x + stack.width) and math.inrange(GUI.MouseY, stack.y, stack.y + stack.height) then
		if math.inrange(GUI.MouseX, x, x + w) and math.inrange(GUI.MouseY, y, y + h) then
			GUI.Hovered = id
			
			if capture == nil or capture == true then
				if GUI.MouseDown and GUI.Active ~= -1 then
					GUI.Active = id
					return true
				end
			end
		end
	end

	return false
end

function GUI:BeginHorizontal()
	local stack = GUI.Stack[1]
	local rect 	= 
		GUI:Push(stack.x + stack.offsetx, stack.y + stack.offsety, stack.width - stack.offsetx, stack.height - stack.offsety)

	rect.vertical 	= false
	rect.scissor 	= false
end

function GUI:EndHorizontal()
	local rect 	= GUI:Pop()
	local stack = GUI.Stack[1]
	
	stack.offsety = rect.y + rect.max_height
	stack.max_width = rect.offsetx
end

function GUI:BeginVertical()
	local stack = GUI.Stack[1]
	local rect 	= 
		GUI:Push(stack.x + stack.offsetx, stack.y + stack.offsety, stack.width - stack.offsetx, stack.height - stack.offsety)

	rect.vertical 	= true
	rect.scissor 	= false
end

function GUI:EndVertical()
	local rect 	= GUI:Pop()
	local stack = GUI.Stack[1]

	stack.offsetx = rect.x + rect.max_width
	stack.max_height = rect.offsety
end

function GUI:Space(amount, ...)
	local stack = GUI.Stack[1]
	
	if stack.vertical then
		stack.offsety = stack.offsety + amount * GUI.PixelScale
	else
		stack.offsetx = stack.offsetx + amount * GUI.PixelScale
	end
end

function GUI:RegisterDraw(draw_func, x, y, w, h, options, ...)
	local parameters = { ... }
	local stack = 
		GUI.Stack[1]
	
	GUI.Canvas:renderTo(function()
		if stack.scissor then
			love.graphics.setScissor(stack.x, stack.y, stack.width, stack.height)
		else
			love.graphics.setScissor()
		end

		draw_func(x, y, w, h, options, unpack(parameters))

		if options.id == GUI.Focused then
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", x, y, w, h)
		end
		
		if stack.scissor then
			love.graphics.setScissor(stack.x, stack.y, stack.width, stack.height)
		else
			love.graphics.setScissor()
		end
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

function GUI:Render()
	if not GUI.MouseDown then
		GUI.Active = nil
	elseif GUI.Active == nil then
		GUI.Active 	= -1
		GUI.Focused = nil
	end
	
	if GUI.Focused then
		if GUI.OnFocused then
			GUI.OnFocused()
			GUI.OnFocused = nil
		end
	end
	
	GUI.LastHovered 	= GUI.Hovered
	GUI.Hovered 		= nil
	GUI.LastFocused 	= nil
	GUI.Index 			= 0
	GUI.MouseDown 		= love.mouse.isDown(1)
	
	local stack = GUI.Stack[1]
	stack.offsetx 		= 0.0
	stack.offsety 		= 0.0
	stack.width 		= Screen.width * GUI.PixelScale
	stack.height 		= Screen.height * GUI.PixelScale
	
	local x, y = Screen.Point(love.mouse.getPosition())
	GUI.MouseX 			= x
	GUI.MouseY 			= y
	GUI.MouseWheel_X 	= 0.0
	GUI.MouseWheel_Y 	= 0.0
	GUI.Key 			= nil
	GUI.KeyPressed 		= nil
end

function GUI.AddSkin(name, skin)
	GUI.Skins[name] = skin
end

function GUI.GetSkin(name)
	return GUI.Skins[name]
end

function GUI:Show()
	love.graphics.reset()
	Screen.Draw(GUI.Canvas, 0.0, 0.0, 0.0)

	GUI.Canvas:renderTo(function()
		love.graphics.clear()
	end)
end