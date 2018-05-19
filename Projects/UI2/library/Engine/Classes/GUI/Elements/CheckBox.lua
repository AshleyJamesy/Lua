local function draw(x, y, w, h, options, checkbox)
	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", x, y, w, h)
	
	if checkbox then
		love.graphics.setColor(0.4, 0.4, 0.4, 1.0)
	else
		love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	end
	
	local ow, oh = w * 0.15, h * 0.15
	love.graphics.rectangle("fill", x + ow, y + oh, w - ow * 2, h - oh * 2)
end

function GUI:CheckBox(checkbox, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	local onClick = false

	if GUI:MousePressed(id) then
		onClick = true
		
		GUI:SetFocus(id)
	end
	
	if GUI:GetFocus(id) then
		if GUI:CaptureKey("return") then
			onClick = true
		end

		if GUI:CaptureKey("tab") then
			if Input.GetKey("lshift") then
				GUI:NextFocus(id, false)
			else
				GUI:NextFocus(id, true)
			end 
		end
	end
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, checkbox)
	GUI:RegisterMouseHit(id, x, y, w, h)

	if onClick then
		return not checkbox
	end

	return checkbox
end