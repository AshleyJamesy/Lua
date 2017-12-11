local Class = class.NewClass("Sprite")

function Class:New(path)
	self.source = love.graphics.newImage(GetProjectDirectory() .. path)
	self.source:setFilter("nearest", "nearest")

	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()

	self.frames 	= {}
	self.animations = {}

	self.frame 	= Rect(0, 0, self.source:getDimensions())
	self.quad 	= love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)	
end

function Class:NewFrame(x,y,w,h)
	table.insert(self.frames, Rect(x,y,w,h))
end

function Class:GetFrame(index)
	return self.frames[index] or self.frame
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