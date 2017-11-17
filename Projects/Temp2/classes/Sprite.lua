local Class = class.NewClass("Sprite", "Asset")
Class.Extenstion = "sprite"

function Class:NewAsset(path)
	self.image 	= Image(path)
	self.frames = {}
	self.pivot 	= Vector2(0.5, 0.5)
	self.animations = {}
	self.batch = love.graphics.newSpriteBatch(self.image.source, 1000)
end

function Class:LoadAsset(asset)
	self.image 	= Image(asset.path)
	self.frames = asset.frames
	self.pivot 	= Vector2(asset.pivot.x, asset.pivot.y)
	self.animations = {}
	self.batch = love.graphics.newSpriteBatch(self.image.source, 1000)

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

function Class:Render(id, quad, x, y, r, sx, sy, ox, oy, colour)
	self.batch:setColor(colour:Unpack())
	if self.batch then
		if id == -1 then
			return self.batch:add(quad, x, y, r, sx, sy, ox, oy)
		else
			self.batch:set(id, quad, x, y, r, sx, sy, ox, oy)
			return id
		end
	else
		love.graphics.draw(self.image.source, quad, x, y, r, sx, sy, ox, oy)
	end
	
	return -1
end

function Class:BatchAdd()
	
end

function Class:BatchClear()
	self.batch:clear()
end