local function draw(x, y, w, h, options, image)
	if options.keepaspect then
		love.graphics.setColor(130, 130, 130, 255)
		love.graphics.rectangle("fill", x, y, w, h)
		love.graphics.setColor(255, 255, 255, 255)
		
		local max 		= math.min(w, h)
		local sx, sy 	= max / image:getWidth(), max / image:getHeight()
		
		love.graphics.draw(image, x + w * 0.5, y + h * 0.5, 0, sx, sy, image:getWidth() * 0.5, image:getHeight() * 0.5)
	else
		love.graphics.draw(image, x, y, 0, w / image:getWidth(), h / image:getHeight())
	end
end

function GUI:Image(image, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	GUI:NextFocus(id, true)
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, image)
end