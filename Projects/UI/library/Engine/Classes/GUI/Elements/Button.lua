local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("Button", skin)

local function draw(x, y, w, h, options, label)
	local skin = options.skin or GUI.GetSkin("Button")
	local font = options.font or GUI.Font
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	love.graphics.printf(label, x, y, w, options.align or "center", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Button(label, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	self:RegisterMouseHit(id, x, y, w, h)
	
	local clicked = false
	
	if id == GUI.Active and id == GUI.Hovered and not GUI.MouseDown then
		GUI:SetFocus(id)
		
		clicked = true
	end
	
	if GUI:GetFocus(id) then
		if GUI.KeyPressed == "return" then
			clicked = true
		end
		
		if GUI.KeyPressed == "tab" then
			GUI.KeyPressed 	= nil
			
			GUI:NextFocus(id)
		end
	end
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, label)
	
	return clicked
end