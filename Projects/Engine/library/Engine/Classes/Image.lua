local Class = class.NewClass("Image")

function Class:New(path)
	self.source = love.graphics.newImage(GetProjectDirectory() .. path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
end