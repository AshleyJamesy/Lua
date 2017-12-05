local Class = class.NewClass("UIInputField", "UIFrame")

local BlinkRate 	= 0.8
local Timer 		= 0.0
local Blink 		= true

function Class:New(parent)
	Class:Base().New(self, parent)
	
	self.colours.default:Set(35,35,35,255)
	self.colours.text = Colour(255,255,255,255)

	self.scissor = true
	
	self.OnPressEvent 		= Delegate()
	self.OnDragEvent 		= Delegate()
	self.OnReleaseEvent 	= Delegate()
	self.OnHoverEnterEvent 	= Delegate()
	self.OnHoverExitEvent 	= Delegate()
	self.OnSubmitEvent 		= Delegate()

	self.cursor 	= 0
	self.cursor_off = 1
	self.text 		= ""
	self.focus 		= false
end

local Font = love.graphics.newFont("resources/fonts/Roboto-Light.ttf")
Font:setFilter("nearest", "nearest", 1)
love.graphics.setFont(Font)

function Class:RenderElement()
	love.graphics.rectangle("fill", self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)
	love.graphics.setColor(self.colours.text.r, self.colours.text.g, self.colours.text.b, self.colours.text.a)

	local font 		= love.graphics.getFont()
	local baseline 	= font:getBaseline()

	if self.scissor then
		love.graphics.intersectScissor(self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)
	end

	love.graphics.print(string.sub(self.text, self.cursor_off, #self.text), self.rects.global.x + 2, self.rects.global.y + baseline * 0.2)

	if self.focus then
		local width = font:getWidth(string.sub(self.text, 1, self.cursor + self.cursor_off - 1))

		if Blink then
			love.graphics.setColor(255,255,255,255)
		else
			love.graphics.setColor(255,255,255,0)
		end

		if Timer >= BlinkRate then
			Blink = not Blink
		end

		Timer = Timer >= BlinkRate and 0 or Timer + Time.Delta

		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("rough")

		love.graphics.line(self.rects.global.x + width + 3, self.rects.global.y + 2, self.rects.global.x + width + 3, self.rects.global.y + self.rects.global.h - 2)
	end
end

function Class:Clear()
	self.text 	= ""
	self.cursor = 0
end

function Class:OnPress(x, y, button, istouch)
	self.focus = true
	local font = love.graphics.getFont()

	for i = 1, #self.text do
		local width = font:getWidth(string.sub(self.text, 1, i))

		if x - self.rects.global.x >= width then
			self.cursor = i
		end
	end

	love.keyboard.setTextInput(true)
end

function Class:OnRelease(x, y, button, istouch)
	if math.inrange(x, self.rects.global.x, self.rects.global.x + self.rects.global.w) and 
		math.inrange(y, self.rects.global.y, self.rects.global.y + self.rects.global.h) then
	else
		self.focus = false
	end

	self:RePaint()
end

function Class:OnHoverEnter(x, y)
	local cursor = love.mouse.getSystemCursor("ibeam")
	love.mouse.setCursor(cursor)
end

function Class:OnHoverExit(x, y)
	local cursor = love.mouse.getSystemCursor("arrow")
	love.mouse.setCursor(cursor)
end

function Class:OnTextInput(char)
	if self.focus then
		self.cursor 	= self.cursor + 1
		self.text 		= self.text .. char

		local font 	= love.graphics.getFont()
		local width = font:getWidth(string.sub(self.text, 1, #self.text))
		if width > self.rects.global.w then
			self.cursor_off = self.cursor_off + 1
		end

		self:RePaint()
	end
end

love.keyboard.setKeyRepeat(true)

function Class:OnKeyPress(key, scancode, isrepeat)
	if self.focus then
		Blink = true
		Timer = 0.0

		if key == "backspace" then
			self.text = 
				string.sub(self.text, 1, math.clamp(self.cursor - 1, 0, #self.text)) .. 
				string.sub(self.text, math.clamp(self.cursor + 1, 0, #self.text + 1), #self.text)

			self.cursor = math.clamp(self.cursor - 1, 0, #self.text)
			self:RePaint()
		elseif key == "delete" then
			self.cursor = self.cursor + 1
			self.text = 
				string.sub(self.text, 1, math.clamp(self.cursor - 1, 0, #self.text)) .. 
				string.sub(self.text, math.clamp(self.cursor + 1, 0, #self.text + 1), #self.text)

			self.cursor = math.clamp(self.cursor - 1, 0, #self.text)
			self:RePaint()
		elseif key == "left" then
			self.cursor = math.clamp(self.cursor - 1, 0, #self.text)
			self:RePaint()
		elseif key == "right" then
			self.cursor = math.clamp(self.cursor + 1, 0, #self.text)
			self:RePaint()
		elseif key == "return" then
			self:OnSubmitEvent(self.text)
			self:Clear()
		end
	end
end