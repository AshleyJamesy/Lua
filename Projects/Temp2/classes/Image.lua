local Class = class.NewClass("Image", "Asset")
Class.Extenstion = "image"

function Class:NewAsset(path)
	self.source = love.graphics.newImage(path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()

	self.source:setFilter("nearest", "nearest")

	self.rect = readOnly{ x = 0, y = 0, w = self.width, h = self.height }
end

function Class:LoadAsset(asset)
	self.source = love.graphics.newImage(asset.path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()

	self.source:setFilter("nearest", "nearest")

	self.rect = readOnly{ x = 0, y = 0, w = self.width, h = self.height }
end

function Class:GetDimensions()
	return self.width, self.height
end