local function draw(x, y, w, h, options, label)
	local font = options.font or GUI.Font
	
	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.setFont(font)
	love.graphics.printf(label, x, y, w, options.align or "center", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Button(label, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	local onClick = false

	if GUI:MousePressed(id) then
		GUI:SetFocus(id)
		onClick = true
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

		if GUI:CaptureKey("escape") then
			GUI:SetFocus(nil)
		end
	end
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, label)
	GUI:RegisterMouseHit(id, x, y, w, h)
	
	return onClick
end