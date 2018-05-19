local function draw(x, y, w, h, options, data)
	local font = options.font or GUI.Font

	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", x, y, w, h)

	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	local tx, ty = x + w - 10, y + h * 0.5
	love.graphics.polygon('fill', tx - 5, ty - 3, tx + 5, ty - 3, tx, ty + 5)
	
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.setFont(font)
	
	love.graphics.printf(data.array[data.index or 1] or "", x + 4, y, w - 20, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)

	if GUI:GetFocus(options.id) then
		local rect = GUI.Stack[1]
		
		GUI.Overlay = function()
			GUI.Canvas:renderTo(function()
				love.graphics.setScissor(rect.x, rect.y, rect.width, rect.height)
				love.graphics.intersectScissor(x, y + h, w, h * #data.array)
     
				local index = data.index
     
				if math.inrange(Input.mousePosition.x, rect.x, rect.x + rect.width) and math.inrange(Input.mousePosition.y, rect.y, rect.y + rect.height) then
					if math.inrange(Input.mousePosition.x, x, x + w) and math.inrange(Input.mousePosition.y, y + h, y + h * (#data.array + 1)) then
						index = math.clamp(math.ceil((Input.mousePosition.y - (y + h)) / h), 1, #data.array)
						
						if Input.GetMouseButton(1) then
							GUI.Active = nil
							GUI:SetFocus(nil)
							
							if index ~= data.index then
							    data.changed = true
							end
							
							data.index = index
						end
					end
				end
     
				love.graphics.setColor(0.4, 0.4, 0.4, 1.0)
				love.graphics.rectangle("fill", x, y + h, w, h * #data.array)
				
				for i = 1, #data.array do
					love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
					love.graphics.setFont(font)
					
					if i == index then
						love.graphics.setColor(0.15, 0.15, 0.15, 1.0)
						love.graphics.rectangle("fill", x, y + h * i, w, h)
						love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
					end
					
					love.graphics.printf(data.array[i] or "", x + 4, y + h * i, math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
				end
			end)
		end
	end
end

function GUI:ComboBox(data, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	if GUI:MousePressed(id) then
		GUI:SetFocus(id)
	end
	
	if GUI:GetFocus(id) then
		if GUI:CaptureKey("up") then
			data.index = data.index - 1

			if data.index < 1 then
				data.index = #data.array
			end
		end
		
		if GUI:CaptureKey("down") then
			data.index = data.index + 1

			if data.index > #data.array then
				data.index = 1
			end
		end
		
		if GUI:CaptureKey("return") then
			GUI:SetFocus(nil)
		end
		
		if GUI:CaptureKey("tab") then
			if Input.GetKey("lshift") then
				GUI:NextFocus(id, false)
			else
				GUI:NextFocus(id, true)
			end 
		end
	end
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, data)
	GUI:RegisterMouseHit(id, x, y, w, h)
 
 if data.changed then
     data.changed = false
     return data.array[data.index] or "", true
 end
 
	return data.array[data.index] or "", false
end