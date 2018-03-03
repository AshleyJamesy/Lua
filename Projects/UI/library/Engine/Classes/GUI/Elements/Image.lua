local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(100))
style:Set(GUIOption.Padding(1, 1))

local default_font = love.graphics.newFont(love.window.getPixelScale() * 12.0)

local skin = GUISkin()
skin.background = Colour(50, 50, 50, 255)
GUI.AddSkin("Image", skin)

local function draw(x, y, w, h, options, image)
	local skin = options.skin or GUI.GetSkin("Image")
	
	if options.keepaspect then
		love.graphics.setColor(skin.background:GetTable())
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
	
	GUI:NextFocus(id)
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, image)
end