local function draw(x, y, w, h, options, data)
	love.graphics.setScissor(x, y, w, h)
	
	local font = options.font or GUI.Font
	
	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.setFont(font)
	
	love.graphics.push()
	love.graphics.translate(0, y + (data.__offsety or 0.0))
	
	for k, v in pairs(data.array) do
	    love.graphics.setColor(0.3, 0.3, 0.3, 1.0)
	    love.graphics.rectangle(data.selected == v and "fill" or "line", x, (k - 1) * (25 * GUI.Scale), w, 25 * GUI.Scale)
	    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	    love.graphics.printf(v, x, (k - 1) * (25 * GUI.Scale), w, options.align or "left", 0.0, 1.0, 1.0, 0.0)
	end
	
	love.graphics.pop()
end

local offset = 0.0
function GUI:ListBox(data, ...)
	local id, x, y, w, h, options = GUI:GetOptions(style, ...)
	
	if GUI:MousePressed(id) then
	    GUI:SetFocus(id)
	    
	    offset = data.__offsety or 0.0
	end
	
	if GUI:GetActive(id) then
	    data.__offsety = math.clamp((data.__offsety or 0.0) + Input.mouseDelta.y, (-#data.array * 25 * GUI.Scale) + h, 0.0)
	end
	
	if GUI:MouseReleased(id) then
	    if math.abs(data.__offsety - offset) < 3 * GUI.Scale then
	        local iy = math.ceil((-data.__offsety + Input.mousePosition.y - y) / (25 * GUI.Scale))
	        if data.array[iy] then
	            data.selected = data.array[iy]
	        else
	            data.selected = ""
	        end
	    end
	    
	    offset = 0.0
	end
	
	GUI:RegisterDraw(options.draw or draw, x, y, w, h, options, data)
	GUI:RegisterMouseHit(id, x, y, w, h)
	
	return data.selected
end