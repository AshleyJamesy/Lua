local Class = class.NewClass("Sprite")
Class.Sprites = {}

--TODO:
--[[
	Unloading sprite / freeing resources
		-Remove hooks
]]
function Class:New(path)
	if Class.Sprites[path] then 
		return Class.Sprites[path] 
	end
	
	self.image 			= Image(path)
	
	self.rect 			= Rect(0, 0, self.image.width, self.image.height)
	self.pixelPerUnit 	= 100
	self.frames 		= {}
	self.animations 	= {}
	
	self.quad 			= graphics.newQuad(0, 0, self.image.width, self.image.height, self.image.width, self.image.height)
	self.batch 			= graphics.newSpriteBatch(self.image.source, 1000, "stream")
	
	Class.Sprites[path] = self

	hook.Add("RenderBatch", self, Class.RenderBatch)
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

function Class:RenderBatch()
	if self.batch then
		graphics.draw(self.batch)
	end
end

function Class:Add(quad, x, y, r, sx, sy, ox, oy)
	return self.batch:add(quad, x, y, r, sx, sy, ox, oy)
end

function Class:Update(id, quad, x, y, r, sx, sy, ox, oy)
	self.batch:set(id, quad, x, y, r, sx, sy, ox, oy)
end