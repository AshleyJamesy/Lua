local Class = class.NewClass("Image")
Class.Images = {}

function Class:New(path)
    if Class.Images[path] then 
        return Class.Images[path]
    end
    
	self.source = love.graphics.newImage(GetProjectDirectory() .. path)
	self.source:setFilter("nearest", "nearest")
	
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
	
	self.halfWidth 	= self.width * 0.5
	self.halfHeight = self.height * 0.5
	
	Class.Images[path] = self
end