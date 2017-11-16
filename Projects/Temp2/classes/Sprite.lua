GetProjectDirectory()local Class = class.NewClass("Sprite", "Asset")
Class.Extenstion = "sprite"

function Class:NewAsset(path)
	self.image 	= Image(path)
	self.frames = {}
	self.pivot 	= Vector2(0.5, 0.5)
	self.animations = {}
end

function Class:LoadAsset(asset)
	self.image 	= Image(asset.path)
	self.frames = asset.frames
	self.pivot 	= Vector2(asset.pivot.x, asset.pivot.y)
	self.animations = {}
	
	for k, v in pairs(asset.animations) do
		self.animations[k] = Animation(unpack(v))
	end
end

function Class:SaveAsset(asset)
	asset.frames = self.frames
	asset.pivot = {
		x = self.pivot.x,
		y = self.pivot.y
	}

	asset.animations = {}
	for k, v in pairs(self.animations) do
		asset.animations[k] = { v.fps, v.loop, v.frames }
	end
end

function Class:AddFrame(x, y, w, h)
	local frame = {}
	frame.name = "frame"
	frame.x = x
	frame.y = y
	frame.w = w
	frame.h = h

	table.insert(self.frames, frame)
end

function Class:GetFrame(i)
	return self.frames[i] or self.image.rect
end

function Class:AddAnimation(name, ...)
	self.animations[name] = Animation(...)
end

function Class:GetAnimation(name)
	return self.animations[name]
end

function Class:Render(quad, x, y, r, sx, sy, colour)
	self.batch:setColor(colour:Unpack())
	self.batch:add(quad, x, y, r, sx, sy)
end