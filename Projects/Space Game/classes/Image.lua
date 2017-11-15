local Class = class.NewClass("Image", "Asset")
Class.Extenstion = "image"

function Class:NewAsset(path)
	self.source = love.graphics.newImage(path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
end

function Class:LoadAsset(asset)
	self.source = love.graphics.newImage(asset.path)
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
end