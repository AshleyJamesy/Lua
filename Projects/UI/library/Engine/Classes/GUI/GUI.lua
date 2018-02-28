local Class = class.NewClass("GUI")
Class.Index 	       	= 0
Class.MouseDown    	= false
Class.Active 	     	= nil
Class.Hovered 	     	= nil
Class.LastHovered  	= nil
Class.Focused 	     	= nil
Class.MouseX        = 0.0
Class.MouseY        = 0.0
Class.MouseWheel_X 	= 0.0
Class.MouseWheel_Y 	= 0.0
Class.Key           = ""
Class.Skins 		      = {}
Class.Canvas        = love.graphics.newCanvas(Screen.width, Screen.height)
GUI.PixelScale      = love.window.getPixelScale()
GUI.Font            = love.graphics.newFont(12.0 * GUI.PixelScale)

Class.Stack = {
	{
		x 			= 0,
		y 			= 0,
		offset_x 	= { 0 },
		offset_y 	= { 0 },
		width 		= Screen.width * GUI.PixelScale,
		height 		= Screen.height * GUI.PixelScale,
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
		scissor 	= true
	}
 
	table.insert(Class.Stack, #Class.Stack + 1, rect)
 
	return rect
end

function Class:Pop()
	table.remove(GUI.Stack, #GUI.Stack, rect)
end

hook.Add("WindowResize", "GUI", function(w, h)
	Class.Canvas = love.graphics.newCanvas(w, h)
end)

hook.Add("MouseWheelMoved", "GUI", function(x, y)
	Class.MouseWheel_X = x
	Class.MouseWheel_Y = y
end)

hook.Add("KeyPressed", "GUI", function(key)
    if key == "escape" then
        love.keyboard.setTextInput(false)
    end
end)

hook.Add("TextInput", "GUI", function(char)
    Class.Key = char
end)

function Class:ResetOptions()
	local options = {}
	
	Class.Index = Class.Index + 1
	
	options.id             = Class.Index	
	options.width          = 0.0
	options.width_min      = 0.0
	options.width_max 		   = math.huge
	options.width_expand   = false
	options.height         = 0.0
	options.height_min     = 0.0
	options.height_max     = math.huge
	options.height_expand  = false
	options.padding_width  = 0.0
	options.padding_height = 0.0
	options.style          = nil
	options.skin           = nil
	
	return options
end

local widths    = { 0.0 }
local heights   = { 0.0 }
local verticals = { true }

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
		(options.width_expand and 
		math.clamp(stack.width - stack_offsetx, options.width_min, options.width_max) or 
		math.clamp(options.width, options.width_min, options.width_max)) * GUI.PixelScale
	
	options.height = 
		(options.height_expand and 
		math.clamp(stack.height - stack_offsety, options.height_min, options.height_max) or 
		math.clamp(options.height, options.height_min, options.height_max)) * GUI.PixelScale
	
	if verticals[#verticals] then
		stack.offset_y[#stack.offset_y] = 
			stack_offsety + options.height + options.padding_height * GUI.PixelScale

		if widths[#widths] < options.width + options.padding_width * GUI.PixelScale then
			widths[#widths] = options.width + options.padding_width * GUI.PixelScale
		end
	else
		stack.offset_x[#stack.offset_x] = 
			stack_offsetx + options.width + options.padding_width * GUI.PixelScale

		if heights[#heights] < options.height + options.padding_height * GUI.PixelScale then
			heights[#heights] = options.height + options.padding_height * GUI.PixelScale
		end
	end
	
	return options.id, stack.x + options.x, stack.y + options.y, options.width, options.height, options
end

function Class:RegisterMouseHit(id, x, y, w, h, capture)
	local stack = GUI.Stack[#GUI.Stack]
	
	if math.inrange(GUI.MouseX, stack.x, stack.x + stack.width) and math.inrange(GUI.MouseY, stack.y, stack.y + stack.height) then
	    if math.inrange(GUI.MouseX, x, x + w) and math.inrange(GUI.MouseY, y, y + h) then
		      Class.Hovered = id
		       
        if capture == nil or capture == true then
            if Class.Active == nil and Class.MouseDown then
                Class.Active = id
                return true
            end
        end
				end
	end

	return false
end

function Class:BeginHorizontal()
	local stack = GUI.Stack[#GUI.Stack]

	table.insert(verticals, #verticals + 1, false)
	table.insert(stack.offset_x, #stack.offset_x + 1, stack.offset_x[#stack.offset_x])
	table.insert(stack.offset_y, #stack.offset_y + 1, stack.offset_y[#stack.offset_y])
 table.insert(heights, #heights + 1, 0.0)
end

function Class:EndHorizontal()
	local stack = GUI.Stack[#GUI.Stack]
	
	table.remove(verticals, #verticals)
	table.remove(stack.offset_x, #stack.offset_x)
	table.remove(stack.offset_y, #stack.offset_y)
	
 stack.offset_y[#stack.offset_y] = stack.offset_y[#stack.offset_y] + heights[#heights]
	
	table.remove(heights, #heights)
end

function Class:BeginVertical()
	local stack = GUI.Stack[#GUI.Stack]
	
	table.insert(verticals, #verticals + 1, true)
	table.insert(stack.offset_x, #stack.offset_x + 1, stack.offset_x[#stack.offset_x])
	table.insert(stack.offset_y, #stack.offset_y + 1, stack.offset_y[#stack.offset_y])
 table.insert(widths, #widths + 1, 0.0)
end

function Class:EndVertical()
	local stack = GUI.Stack[#GUI.Stack]
	
	table.remove(verticals, #verticals)
	table.remove(stack.offset_x, #stack.offset_x)
	table.remove(stack.offset_y, #stack.offset_y)
	
	stack.offset_x[#stack.offset_x] = stack.offset_x[#stack.offset_x] + widths[#widths]
	
	table.remove(widths, #widths)
end

function GUI:Space(amount, ...)
	local stack = GUI.Stack[#GUI.Stack]
	
	if verticals[#verticals] then
		stack.offset_y[#stack.offset_y] = stack.offset_y[#stack.offset_y] + amount * GUI.PixelScale
	else
		stack.offset_x[#stack.offset_x] = stack.offset_x[#stack.offset_x] + amount * GUI.PixelScale
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
 
 Class.LastHovered = Class.Hovered
 Class.Hovered = nil
	Class.Index 			= 0
	Class.MouseDown 		= love.mouse.isDown(1)

	local stack = Class.Stack[#Class.Stack]
	stack.offset_x[1] = 0.0
	stack.offset_y[1] = 0.0
 stack.width = Screen.width * GUI.PixelScale
 stack.height = Screen.height * GUI.PixelScale
 
 local x, y = Screen.Point(love.mouse.getPosition())
 Class.MouseX = x
 	Class.MouseY = y
	Class.MouseWheel_X = 0.0
	Class.MouseWheel_Y = 0.0
	Class.Key = ""
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