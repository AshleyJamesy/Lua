local Class = class.NewClass("Sprite", "Asset")
Class.extension = "sprite"

function Class:Load(asset)
		self.pivot 		= asset.pivot
		self.frames 	= asset.frames
		self.animations = asset.animations
	else
		--default values if asset doesn't exist (we create one)
		self.pivot 		= Vector2(0.5,0.5)
		self.frames 	= {}
		self.animations = {}
	end
	
	self.image = love.graphics.newImage(self.path)
	self.image:setFilter("nearest", "nearest")
end

function Class:NewFrame(x,y,w,h)
	table.insert(self.frames, Rect(x,y,w,h))
end

function Class:GetFrame(index)
	return self.frames[index] or Rect(0, 0, self.image:getDimensions())
end

function Class:NewAnimation(name, animation)
	self.animations[name] = animation
end

function Class:GetAnimation(name)
	return self.animations[name]
end