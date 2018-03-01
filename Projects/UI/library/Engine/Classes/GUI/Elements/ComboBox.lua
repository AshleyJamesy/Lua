local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("ComboBox", skin)

local function draw(x, y, w, h, options, data)
	local skin = options.skin or GUI.GetSkin("ComboBox")
	local font = options.font or GUI.Font
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	
	love.graphics.printf(data.array[data.index or 1] or "", x + 4, y, w - 8, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
	
	if GUI.Focused == options.id then
		GUI.OnFocused = function()
			GUI.Canvas:renderTo(function()
				love.graphics.setScissor(x, y + h, w, h * #data.array)

				local index = data.index
				if math.inrange(GUI.MouseX, x, x + w) and math.inrange(GUI.MouseY, y + h, y + h * (#data.array + 1)) then
					index = math.clamp(math.ceil((GUI.MouseY - (y + h)) / h), 1, #data.array)

					if love.mouse.isDown(1) then
						GUI.LastFocused = GUI.Focused
						GUI.Focused 	= nil
						GUI.Active 		= -1

						data.index = index
					end
				end
				
				love.graphics.setColor(100, 100, 100)
				love.graphics.rectangle("fill", x, y + h, w, h * #data.array)
				
				for i = 1, #data.array do
					love.graphics.setColor(skin.text:GetTable())
					love.graphics.setFont(font)
					
					if i == index then
						love.graphics.setColor(40, 40, 40)
						love.graphics.rectangle("fill", x, y + h * i, w, h)
						love.graphics.setColor(skin.text:GetTable())
					end

					love.graphics.printf(data.array[i] or "", x + 4, y + h * i, math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
				end
			end)
		end
	end

	options.selection = data.array[data.index]
end

function GUI:ComboBox(data, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	GUI:RegisterMouseHit(id, x, y, w, h)
	
	if GUI.Focused == id then
		if GUI.KeyPressed == "up" then
			data.index = data.index - 1

			if data.index < 1 then
				data.index = #data.array
			end
		end

		if GUI.KeyPressed == "down" then
			data.index = data.index + 1

			if data.index > #data.array then
				data.index = 1
			end
		end

		if GUI.KeyPressed == "return" then
			GUI.LastFocused = GUI.Focused
			GUI.Focused 	= nil
		end
	end

	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, data)
	
	return options.selection
end