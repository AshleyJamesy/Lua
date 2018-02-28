local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("Input", skin)

local function draw(x, y, w, h, options, data)
	local skin = options.skin or GUI.GetSkin("Input")
	local font = options.font or GUI.Font
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setScissor(x, y, w, h)
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	--love.graphics.printf(text, x, y, (options.wrap or options.width_expand) and w or math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)

	local text = 
		(data.text == nil or data.text == "") and data.candidate or data.text or ""
	
	if GUI.Focused == options.id then
		text = string.sub(data.text or "", 1, GUI.Cursor) .. "|" .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)
	end
	
	if data.text ~= "" and data.password then
		text = string.gsub(text, "%a", "*")
	end

	love.graphics.printf(text, x, y, (options.wrap or options.width_expand) and w or math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Input(data, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	self:RegisterMouseHit(id, x, y, w, h)
	
	if id == GUI.Active and id == GUI.Hovered and GUI.MouseDown then
		GUI.Cursor = #data.text
	end
	
	if id == GUI.Active and id == GUI.Hovered and not GUI.MouseDown then
		if not love.keyboard.hasTextInput() then
			love.keyboard.setTextInput(true)
		end
	end

	if GUI.Focused == id then
		if GUI.KeyPressed then
			if GUI.KeyPressed == "left" then
				 GUI.Cursor = math.clamp(GUI.Cursor - 1, 0, #data.text)
			end

			if GUI.KeyPressed == "right" then
				 GUI.Cursor = math.clamp(GUI.Cursor + 1, 0, #data.text)
			end

			if GUI.KeyPressed == "backspace" then
				if GUI.Cursor > 0 then
					data.text = string.sub(data.text or "", 1, GUI.Cursor - 1) .. string.sub(data.text or "", GUI.Cursor + 1, #data.text)
					GUI.Cursor = math.clamp(GUI.Cursor - 1, 0, #data.text)
				end
			end

			if GUI.KeyPressed == "return" then
				if options.multiline then
					data.text = data.text .. "\n"
				else
					if data.onSubmit then
						data.onSubmit(data)
					end
				end
			end

			if GUI.Key then
				data.text = data.text .. GUI.Key
				GUI.Cursor = math.clamp(GUI.Cursor + 1, 0, #data.text)
			end
		end
	end
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, data)
end