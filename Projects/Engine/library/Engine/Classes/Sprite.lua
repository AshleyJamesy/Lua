local Class = class.NewClass("Sprite")
Class.Sprites = {}

love.graphics.setDefaultFilter("nearest", "nearest")

function Class:New(path)
	if Class.Sprites[path] then 
		return Class.Sprites[path] 
	end

	self.image 			= Image(path)
	
	self.rect 			= Rect(0, 0, self.image.width, self.image.height)
	self.pixelPerUnit 	= 100
	self.frames 		= {}
	self.animations 	= {}
	
	self.quad = love.graphics.newQuad(0, 0, self.image.width, self.image.height, self.image.width, self.image.height)
	
	Class.Sprites[path] = self
end

function Class:NewFrame(x,y,w,h)
	table.insert(self.frames, Rect(x,y,w,h))
end

function Class:GetFrame(index)
	return self.frames[index] or self.rect
end

function Class:NewAnimation(name, animation)
	self.animations[name] = animation
end

function Class:GetAnimation(name)
	return self.animations[name]
end

function Class:SetFrame(index)
	local frame = self.frames[index]
	if frame then
		self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
	end
end