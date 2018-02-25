local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(20))
style:Set(GUIOption.Padding(1, 1))

local skin = GUISkin()
skin.background = Colour(130, 130, 130, 255)
skin.text 		= Colour(255, 255, 255, 255)
GUI.AddSkin("Input", skin)

local function draw(x, y, w, h, options, text)
	local skin = options.skin or GUI.GetSkin("Input")
	local font = options.font or GUI.Font
	
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
	
	love.graphics.setScissor(x, y, w, h)
	love.graphics.setColor(skin.text:GetTable())
	love.graphics.setFont(font)
	love.graphics.printf(text, x, y, (options.wrap or options.width_expand) and w or math.huge, options.align or "left", 0.0, 1.0, 1.0, 0.0, h * -0.5 + font:getHeight() * 0.5)
end

function GUI:Input(text, ...)
	local id, x, y, w, h, options = self:GetOptions(style, ...)
	
	self:RegisterMouseHit(id, x, y, w, h)
	
	if id == GUI.Active and id == GUI.Hovered and not GUI.MouseDown then
	    if not love.keyboard.hasTextInput() then
	        love.keyboard.setTextInput(true)
	    end
	    
	    GUI.Focused = id
	end
	
	local new = text
	if GUI.Focused == id then
	    if GUI.Key == "\n" then
	        love.keyboard.setTextInput(false)
	    else
	        new = new .. GUI.Key
	    end
	end
	
	self:RegisterDraw(options.draw or draw, x, y, w, h, options, text)
	
	return new
end