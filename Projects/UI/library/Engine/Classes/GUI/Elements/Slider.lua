local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("Slider", skin)

local function draw(x, y, w, h, options, value, vertical)
	local skin = options.skin or GUI.GetSkin("Slider")
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(skin.text:GetTable())
	
	if vertical then
		love.graphics.rectangle("fill", x, y + h, w, -h * value)
	else
		love.graphics.rectangle("fill", x, y, value * w, h)
	end
end

function GUI:Slider(value, vertical, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	options.state = self:RegisterMouseHit(id, x, y, w, h)

	if id == GUI.Active and GUI.MouseDown then
		if vertical then
			value = 1.0 - (GUI.MouseY - y) / h
		else
			value = (GUI.MouseX - x) / w
		end
		
		GUI:SetFocus(id)
	end
	
	if GUI:GetFocus(id) then
		if GUI:CaptureKey("tab") then
			GUI:NextFocus(id)
		end
	end
	
	value = math.clamp(value, 0.0, 1.0)
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, value, vertical)
	
	return value
end