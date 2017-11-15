local Class = class.NewClass("Image")

function Class:New(path)
	self.source = love.graphics.newImage(path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
end