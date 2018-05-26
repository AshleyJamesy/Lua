local colour = { 0.3, 0.3, 0.3, 1.0 }

local function draw(x, y, w, h, options) 
	love.graphics.setColor(options.colour or colour)
	love.graphics.rectangle("fill", x, y, w, h)
end

function GUI:BeginArea(fx, fy, w, h, ox, oy, ...)
	local id, x, y, w, h, options = self:GetOptions(style, GUIOption.Width(w), GUIOption.Height(h), ...)
	local rect = GUI.Stack[1]
 	
	x = fx == nil and x or (fx * GUI.Scale + rect.x)
	y = fy == nil and y or (fy * GUI.Scale + rect.y)
	
	local rect = GUI:Push(x, y, w, h)
	rect.offsetx = ox or 0.0
	rect.offsety = oy or 0.0
	
	GUI:NextFocus(id)
	
	GUI:RegisterDraw(draw, x, y, w, h, options)
	GUI:RegisterMouseHit(id, x, y, w, h)
end

function GUI:EndArea()
	GUI:Pop()
end