local style = GUIStyle()
style:Set(GUIOption.Width(20))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin 	= GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.on 		= Colour(100, 100, 100, 255)
skin.off 		= Colour(130, 130, 130, 255)
GUI.AddSkin("CheckBox", skin)

local function draw(x, y, w, h, options, checkbox)
	local skin = options.skin or GUI.GetSkin("CheckBox")
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)

	if checkbox then
		love.graphics.setColor(skin.on:GetTable())
	else
		love.graphics.setColor(skin.off:GetTable())
	end
	
	local ow, oh = w * 0.15, h * 0.15
	love.graphics.rectangle("fill", x + ow, y + oh, w - ow * 2, h - oh * 2)
end

function GUI:CheckBox(checkbox, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	local clicked = false

	self:RegisterMouseHit(id, x, y, w, h)

	if id == GUI.Active and id == GUI.Hovered and not GUI.MouseDown then
		clicked = true
		
		GUI:SetFocus(id)
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
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, checkbox)
	
	if clicked then
		return not checkbox
	end

	return checkbox
end