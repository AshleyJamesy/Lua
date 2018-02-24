local default_style = GUIStyle()
default_style:Set(GUIOption.Width(200))
default_style:Set(GUIOption.Height(50))

local default_skin = GUISkin()
default_skin.background = Colour(150, 150, 150, 255)
default_skin.foreground = Colour(100, 100, 100, 255)
default_skin.text 		= Colour(0, 0, 0, 255)
GUI.AddSkin("Button", default_skin)

local function draw_button(x, y, w, h, options, label)
	local skin = options.skin or GUI.GetSkin("Button")
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(skin.foreground:GetTable())
	love.graphics.rectangle("line", x, y, w, h)
	love.graphics.setColor(skin.text:GetTable())
	
	love.graphics.setFont(options.font)
	love.graphics.printf(label, x, y, w, options.align or "center", 0.0, 1.0, 1.0, 0.0, h * -0.5 + options.font:getHeight() * 0.5)
end

function GUI:Button(label, ...)
	local id, x, y, w, h, options = self:GetOptions(default_style, ...)
	
	options.state = self:RegisterMouseHit(id, x, y, w, h)
	self:RegisterDraw(options.draw or draw_button, x, y, w, h, options, label)
	
	return self:Element(id, options)
end