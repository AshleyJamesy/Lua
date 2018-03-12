local function draw(x, y, w, h, options)
	love.graphics.setColor(80, 80, 80, 255)
	love.graphics.rectangle("fill", x, y, w, h)
end

function GUI:BeginArea(fx, fy, w, h, ...)
	local id, x, y, w, h, options = self:GetOptions(style, GUIOption.Width(w), GUIOption.Height(h), ...)
	
	x = fx == nil and x or fx
	y = fy == nil and y or fy
	
	GUI:Push(x, y, w, h)
	
	GUI:NextFocus(id)
	
	self:RegisterDraw(draw, x, y, w, h, options)
end

function GUI:EndArea()
	GUI:Pop()
end