local function draw(x, y, w, h, options, value, min, max)
	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.rectangle("fill", x, y, ((value - min) / (max - min)) * w, h)
end

function GUI:Slider(value, min, max, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	local i = math.clamp((Input.mousePosition.x - x) / w, 0.0, 1.0)

	if GUI:MousePressed(id) then
		GUI:SetFocus(id)
	end

	if GUI:GetActive(id) then
		value = (i * (max - min)) + min
	else
		if GUI:GetFocus(id) then
			if GUI:CaptureKey("tab") then
				if Input.GetKey("lshift") then
					GUI:NextFocus(id, false)
				else
					GUI:NextFocus(id, true)
				end 
			end

			if GUI:CaptureKey("escape") then
				GUI:SetFocus(nil)
			end
		end
	end
	
	value = math.clamp(value, min, max)
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, value, min, max)
	GUI:RegisterMouseHit(id, x, y, w, h)
	
	return value
end