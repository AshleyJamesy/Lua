local function draw(x, y, w, h, options, image)
	if options.keepaspect then
		love.graphics.setColor(0.1, 0.1, 0.1, 1.0)
		love.graphics.rectangle("fill", x, y, w, h)
		love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
		
		local scale = math.min(w / image:getWidth(), h / image:getHeight())
		
		love.graphics.draw(image, x + w * 0.5, y + h * 0.5, 0, scale, scale, image:getWidth() * 0.5, image:getHeight() * 0.5)
	else
		love.graphics.draw(image, x, y, 0, w / image:getWidth(), h / image:getHeight())
	end
end

function GUI:Image(image, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	GUI:NextFocus(id, true)
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, image)
end