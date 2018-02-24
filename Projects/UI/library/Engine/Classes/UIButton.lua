local Class = class.NewClass("UIButton")

local mouse_Capture = nil

local mainFont = 
	love.graphics.newFont(love.window.getPixelScale() * 12)

function Class.Captured()
	return mouse_Capture ~= nil
end

function Class:New(x, y, w, h, text)
	self.state 	= "Up"
	self.text 	= text or "Button"
	
	self.active 	= true
	self.visible 	= true
	self.toggle 	= false
	self.position 	= Vector2(x, y)
	self.anchor 	= Vector2(0.0, 0.0)
	self.stretch 	= Vector2(0.0, 0.0)
	self.min 		= Vector2(w, h)
	self.max 		= Vector2(math.huge, math.huge)
	
	self.rect = {
		x = 0.0,
		y = 0.0,
		w = 0.0,
		h = 0.0
	}
	
	self.colours 			= {}
	self.colours.background = Colour(100, 100, 100, 255)
	self.colours.text 		= Colour(255, 255, 255, 255)
	
	self.image = nil
	
	self.onClick = {}
end

function Class:CalculateRect()
	local rect = self.rect
	rect.w = 
		math.clamp(self.stretch.x * love.graphics.getWidth(), self.min.x, self.max.x)
	rect.h = 
		math.clamp(self.stretch.y * love.graphics.getHeight(), self.min.y, self.max.y)
	
	rect.x = self.position.x - rect.w * self.anchor.x
	rect.y = self.position.y - rect.h * self.anchor.y
end

function Class:Update()
	self:CalculateRect()

	if self.visible then
		if love.mouse.isDown(1) then
			local mx, my = Screen.Point(love.mouse.getPosition())
			if math.inrange(mx, self.rect.x, self.rect.x + self.rect.w) and math.inrange(my, self.rect.y, self.rect.y + self.rect.h) then
				mouse_Capture = self.active and self or mouse_Capture
			end
		end
	end

	if mouse_Capture == self then
		if not love.mouse.isDown(1) then
			if self.active then
				local mx, my = Screen.Point(love.mouse.getPosition())
				if math.inrange(mx, self.rect.x, self.rect.x + self.rect.w) and math.inrange(my, self.rect.y, self.rect.y + self.rect.h) then
					self.toggle = not self.toggle

					for k, v in pairs(self.onClick) do
						v(self)
					end
				end
			end
			
			mouse_Capture = nil
		end
	end
end

function Class:Hook(func)
	table.insert(self.onClick, 1, func)
end

function Class:RenderUI()
	if self.visible then	
		local rect = self.rect
		
		love.graphics.setColor(self.colours.background:GetTable())
		love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
		love.graphics.setColor(150,150,150,255)
		love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h)
		love.graphics.setColor(self.colours.text:GetTable())

		love.graphics.setFont(mainFont)
		
		love.graphics.printf(self.text, rect.x, rect.y, rect.w, "center", 0.0, 1.0, 1.0, 0.0, (rect.h * -0.5) + mainFont:getHeight() * 0.5)
	end
end