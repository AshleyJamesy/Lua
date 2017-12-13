include("class")
include("composition/components/Animation")
include("composition/components/Sprite")
include("composition/MonoBehaviour")
include("types/Colour")

local Class, BaseClass = class.NewClass("SpriteRenderer", "MonoBehaviour")
SpriteRenderer = Class

--[[
SpriteRenderer.sort =  function(a, b)
	return a.sortingIndex > b.sortingIndex
end
]]

function Class:Awake()
	self.sortingIndex	= 0
	
	--animation
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.animations 		= {}
	self.isPlaying			= false

	--rendering
	self.xflip 			= false
	self.yflip			= false
	self.colour 		= Colour(255,255,255,255)
	self.sprite 		= Sprite(git .. "resources/sprites/hero.png")

	table.insert(self.sprite.frames, {x=16,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=64,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=80,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=96,y=16,w=16,h=16})
	table.insert(self.sprite.frames, {x=16,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=64,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=80,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=96,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=16,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=64,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=80,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=96,y=48,w=16,h=16})
	table.insert(self.sprite.frames, {x=16,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=64,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=80,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=96,y=64,w=16,h=16})
	table.insert(self.sprite.frames, {x=16,y=80,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=80,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=80,w=16,h=16})

	self:AddAnimation("idle", Animation(1.0, true, { 1, 2, 3, 4 }))
	self:AddAnimation("walk", Animation(12.0, true, { 7, 8, 9, 10, 11, 12 }))
	self:AddAnimation("jump", Animation(1.0, false, { 13 }))
	self:AddAnimation("land", Animation(1.0, false, { 14, 15 }))
	self:AddAnimation("swim", Animation(5.0, true, { 19, 20, 21, 22, 23, 24 }))
	
	local w, h 	= self.sprite.image:getDimensions()
	self.quad 	= love.graphics.newQuad(0, 0, w, h, w, h)

	if self.sprite.frames[1] then
		local frame = self.sprite.frames[1]
		self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
	end
	
	self:PlayAnimation("idle")
end

function Class:Reset(name)
	local animation = self.animations[name or self.animation]

	self.animation_index = 1
	self.timer 			 = 1 / animation.fps

	local frame = self:GetFrame(1)

	self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
end

function Class:GetAnimation()
	return self.animations[self.animation]
end

function Class:GetFrame(index)
	return self.sprite.frames[self:GetAnimation().frames[index]]
end

function Class:PlayAnimation(name)
	if self.animation == name then
	else
		if self.animations[name] then
			self.animation = name
			self.isPlaying = true
			self:Reset()
		end
	end
end

function Class:AddAnimation(name, animation)
	self.animations[name] = animation
end

function Class:StopAnimation()
	self.animation = ""
end

function Class:Render()
	local animation = self.animations[self.animation]

	if animation then
		self.timer = self.timer - (Time.delta * self.speed)

		if self.timer <= 0 then
			self.animation_index = self.animation_index + 1
			self.timer = 1 / animation.fps

			if self.animation_index > #animation.frames then
				if animation.loop then
					self.animation_index = 1
				else
					self.animation_index 	= #animation.frames
					self.isPlaying 			= false
				end
			end

			local frame = self:GetFrame(self.animation_index)

			self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
		end
	end

	local x, y, w, h = self.quad:getViewport()
	love.graphics.setColor(self.colour:Unpack())

	local xf = self.xflip and -1 or 1
	local yf = self.yflip and -1 or 1

	love.graphics.draw(self.sprite.image, self.quad, -w * self.sprite.pivot.x * xf, -h * self.sprite.pivot.y * yf, 0, xf, yf)
end
	