local function draw(x, y, w, h, options, array)
	local font = options.font or GUI.Font
	
	love.graphics.setColor(130, 130, 130, 255)
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font)
	
	for k, v in pairs(array) do
	    love.graphics.setColor(100, 100, 100, 255)
	    love.graphics.rectangle("fill", x, y + (k - 1) * 45 + (k * 5), w, 45)
	    love.graphics.setColor(255, 255, 255, 255)
	    love.graphics.printf(v, x, y + (k - 1) * 45 + (k * 5), w, options.align or "left", 0.0, 1.0, 1.0, 0.0)
	end
end

function GUI:ListBox(data, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, data.array)
	GUI:RegisterMouseHit(id, x, y, w, h)
end