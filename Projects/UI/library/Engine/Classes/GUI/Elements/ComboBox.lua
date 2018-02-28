local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("ComboBox", skin)

local function draw(x, y, w, h, options, opened, selections, selected)
	local skin = options.skin or GUI.GetSkin("ComboBox")
	local font = options.font or GUI.Font
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	love.graphics.printf(label, x, y, w, options.align or "center", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:ComboxBox(opened, selections, selected, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	self:RegisterMouseHit(id, x, y, w, h)
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, label)
	
	return id == GUI.Active and id == GUI.Hovered and not GUI.MouseDown
end