local Class = class.NewClass("UICanvas", "UIElement")

function Class:New(w, h, ...)
	Class:Base().New(self, ...)
	
	self.canvas = love.graphics.newCanvas(w, h)
	self.usingWidth 	= w and false or true
	self.usingHeight 	= h and false or true

	self.rects.native.w = self.canvas:getWidth()
	self.rects.native.h = self.canvas:getHeight()

	self.colour:Set(0,0,0,0)
	
	hook.Add("MousePressed",	self, self.MousePressed)
	hook.Add("MouseReleased",	self, self.MouseReleased)
	hook.Add("MouseMoved",		self, self.MouseMoved)
	hook.Add("MouseWheelMoved",	self, self.MouseWheel)
	hook.Add("WindowResize",	self, self.WindowResize)
	hook.Add("TextInput",		self, self.TextInput)
	hook.Add("KeyPressed", 		self, self.KeyPressed)

	self.__paint = true
end

function Class:RePaint()
	self.__paint = true
end

function Class:Render()
	if self.__paint then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.colour.r, self.colour.g, self.colour.b, self.colour.a)

		self:DoDestroy()
		self:Paint()
		
		love.graphics.setCanvas()
		love.graphics.setScissor()
	end
	
	self.__paint = false

	if self.visible then
		self:DoHover(love.mouse.getPosition())

		love.graphics.draw(self.canvas, 0, 0, 0, 1, 1)
	end
end

function Class:WindowResize(w, h)
	self.canvas = love.graphics.newCanvas(self.usingWidth and self.rects.native.w or w, self.usingHeight and self.rects.native.h or h)

	self.rects.native.w = self.canvas:getWidth()
	self.rects.native.h = self.canvas:getHeight()

	self:RePaint()
end