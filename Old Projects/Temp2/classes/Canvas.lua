local Class = class.NewClass("Canvas")

function Class:New(width, height)
	self.source = love.graphics.newCanvas(width, height)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
	
	self.source:setFilter("nearest", "nearest")
	
	self.rect = readOnly{ x = 0, y = 0, w = self.width, h = self.height }
end

function Class:GetWidth()
	return self.width
end

function Class:GetHeight()
	return self.height
end

function Class:GetDimensions()
	return self.width, self.height
end