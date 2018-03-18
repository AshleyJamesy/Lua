local function draw(x, y, w, h, options, data)
	local font = options.font or GUI.Font
	
	love.graphics.setColor(130, 130, 130, 255)
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.intersectScissor(x, y, w, h)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font)
	
	local text = 
		(data.text == nil or data.text == "") and data.candidate or data.text or ""
	
	if GUI.Focused == options.id then
		text = string.sub(data.text or "", 1, GUI.Cursor) .. (GUI.CursorVisible and "|" or "") .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)
	end
	
	if data.text ~= "" and data.password then
		text = string.gsub(text, "[%a%s]", "*")
	end
	
	local foy = h * -0.5 + font:getHeight() * 0.5
	if options.valign then
		if options.valign == "top" then
			foy = 0.0
		end

		if options.valign == "middle" then
			foy = h * -0.5 + font:getHeight() * 0.5
		end
	end

	love.graphics.printf(text, x, y, options.wrap == true and w or math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, foy)
end

--[[
TODO:
	-Put Cursor at MousePosition
	-Offseting
	-Highlight/Copying
]]
function GUI:Input(data, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	if data.enabled then
	if GUI:MousePressed(id) then
		if not love.keyboard.hasTextInput() then
			love.keyboard.setTextInput(true)
		end
		
		--TODO: Put Cursor at MousePosition
		local i = math.floor((Input.mousePosition.x - x) / 12)
	 GUI:SetCursor(i, #data.text)
		
		GUI:SetFocus(id)
	end
	
	if GUI:GetActive(id) then
	    local i = math.floor((Input.mousePosition.x - x) / 12)
	    GUI:SetCursor(i, #data.text)
	end
	
	if GUI:GetFocus(id) then
		if GUI:AnyKey() then
			if data.multiline then
				if GUI:CaptureKey("up") then
					
				end

				if GUI:CaptureKey("down") then
					
				end
			end

			if GUI:CaptureKey("left") then
				 GUI:MoveCursor(-1, #data.text)
			end
			
			if GUI:CaptureKey("right") then
				 GUI:MoveCursor(1, #data.text)
			end
			
			if GUI:CaptureKey("backspace") then
				if GUI.Cursor > 0 then
					data.text = 
						string.sub(data.text or "", 1, GUI.Cursor - 1) .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)
					
					GUI:MoveCursor(-1, #data.text)
				end

				GUI:MoveCursor(0, #data.text)
			end
			
			if GUI:CaptureKey("delete") then
				data.text = 
					string.sub(data.text or "", 1, GUI.Cursor) .. string.sub(data.text or "", GUI.Cursor + 2, #data.text)

				GUI:MoveCursor(0, #data.text)
			end

			if GUI:CaptureKey("return") then
				if data.multiline then
					data.text = data.text .. "\n"

					GUI:MoveCursor(1, #data.text)
				else
					if data.OnSubmit then
						data.OnSubmit(data)
					end

					GUI:NextFocus(id, true)
				end
			end
			
			if GUI:CaptureKey("tab") then
				if data.multiline then
					data.text = data.text .. "\t"

					GUI:MoveCursor(1, #data.text)
				else
					if Input.GetKey("lshift") then
						GUI:NextFocus(id, false)
					else
						GUI:NextFocus(id, true)
					end
				end
			end
			
			if Input.GetKey("lctrl") then
				if Input.GetKey("v") then
					local append = love.system.getClipboardText()
					
					data.text = 
						string.sub(data.text or "", 1, GUI.Cursor) .. append .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)
					
					GUI:MoveCursor(#append, #data.text)
				end

				if Input.GetKey("c") then
					love.system.setClipboardText(data.text)
				end

				if Input.GetKey("x") and not data.password then
					love.system.setClipboardText(data.text)
					
					data.text = ""
					GUI:SetCursor(0)
				end
			end

			if GUI.Key and not Input.GetKey("lctrl") then
				data.text = 
					string.sub(data.text or "", 1, GUI.Cursor) .. GUI.Key .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)

				GUI:MoveCursor(1, #data.text)
			end
		end
		else
		
		end
	end
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, data)
	GUI:RegisterMouseHit(id, x, y, w, h)
end