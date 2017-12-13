local Class = class.NewClass("Canvas")

function Class:New(w, h)
	self.source = love.graphics.newCanvas()
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
end