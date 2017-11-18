local Class = class.NewClass("Sprite", "Asset")
Class.Extenstion = "sprite"

function Class:NewAsset(path)
	self.image 	= Image(path)
	self.frames = {}
	self.pivot 	= Vector2(0.5, 0.5)
	self.animations = {}
	--self.batch = love.graphics.newSpriteBatch(self.image.source, 1000)
	
	self.previous  = 0
	self.counter   = 0
	self.index     = 0
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
	
	self.previous  = 0
	self.counter   = 0
	self.index     = 0
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

function Class:Render(quad, x, y, r, sx, sy, ox, oy, colour)
	if self.batch then
	 self:BatchAdd(quad, x, y, r, sx, sy, ox, oy, colour)
	else
	 love.graphics.setColor(colour:Unpack())
		love.graphics.draw(self.image.source, quad, x, y, r, sx, sy, ox, oy)
	end
end

function Class:FinishBatch()
    love.graphics.draw(self.batch)
    
    if self.counter < self.previous then
        self.batch:clear()
        self.previous = 0
    else
        self.previous = self.counter
    end
    
    self.index = 0
end

function Class:BatchAdd(quad, x, y, r, sx, sy, ox, oy, colour)
    self.batch:setColor(colour:Unpack())
    
    self.index   = self.index + 1
    self.counter = self.index
    
    if self.index > self.previous then
        self.batch:add(quad, x, y, r, sx, sy, ox, oy)
    else
        self.batch:set(self.index, quad, x, y, r, sx, sy, ox, oy)
    end
end