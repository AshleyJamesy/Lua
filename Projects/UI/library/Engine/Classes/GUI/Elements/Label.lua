local style = GUIStyle()
style:Set(GUIOption.Width(80))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(0, 1))
style:Set(GUIOption.Align("left"))

local skin 	= GUISkin()
skin.text 	= Colour(255, 255, 255, 255)
GUI.AddSkin("Label", skin)

local function draw(x, y, w, h, options, label)
	local skin = options.skin or GUI.GetSkin("Label")
	local font = options.font or GUI.Font
 
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	love.graphics.printf(label, x, y, (options.wrap or options.width_expand) and w / GUI.PixelScale or math.huge, options.align or "center", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Label(label, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)

	self:RegisterDraw(options.draw or draw, x, y, w, h, options, label)
end