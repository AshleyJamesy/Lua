local colour = { 80, 80, 80, 255 }

local function draw(x, y, w, h, options)
 
	love.graphics.setColor(options.colour or colour)
	love.graphics.rectangle("fill", x, y, w, h)
end

function GUI:BeginArea(fx, fy, w, h, ...)
	local id, x, y, w, h, options = self:GetOptions(style, GUIOption.Width(w), GUIOption.Height(h), ...)
	local rect = GUI.Stack[1]
	
	x = fx == nil and x or (fx + rect.x)
	y = fy == nil and y or (fy + rect.y)
	
	GUI:Push(x, y, w, h)
	
	GUI:NextFocus(id)
	
	self:RegisterDraw(draw, x, y, w, h, options)
	GUI:RegisterMouseHit(id, x, y, w, h)
end

function GUI:EndArea()
	GUI:Pop()
end