local function draw(x, y, w, h, options, label)
	local font = options.font or GUI.Font
	
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.setFont(font)
	love.graphics.printf(label, x, y, w, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Label(label, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	GUI:NextFocus(id)
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, label)
end