local Class = Script("SpriteRenderer")

function Class:Awake(...)
	self.sortingIndex 		= 0
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.playing 			= false
	self.xflip 				= 0
	self.yflip 				= 0
	self.colour = Colour(255)
	--self.sprite = Sprite(...)
end

function Class:SetSprite(sprite)
	if sprite then
		self.sprite = sprite
		
		local w, h 	= self.sprite.image:getDimensions()
		self.quad 	= love.graphics.newQuad(0, 0, w, h, w, h)

		local frame = self.sprite:GetFrame(1)
		
		if frame then
			self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
		end
	end
end

function Class:Reset(name)
	local animation = self.sprite:GetAnimation(name or self.animation)

	self.animation_index = 1
	self.timer 			 = 1 / animation.fps
	
	local frame = self.sprite:GetFrame(1)
	
	self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
end

function Class:PlayAnimation(name)
	if self.animation == name then
	else
		if self.sprite then
			if self.sprite:GetAnimation(name) then
				self.animation = name
				self.playing = true
				self:Reset()
			end
		end
	end
end

function Class:StopAnimation()
	self.animation = ""
end

function Class:Update()
	if self.sprite then
		local animation = self.sprite:GetAnimation(self.animation)
		
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
						self.playing 			= false
					end
				end
				
				local frame = self.sprite:GetFrame(animation.frames[self.animation_index])
				
				self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
			end
		end
	end
end

function Class:Render()
	if self.sprite then
		local x, y, w, h = self.quad:getViewport()
		local vec = self.sprite.pivot * self.flip

		love.graphics.setColor(self.colour:Unpack())
		love.graphics.draw(self.sprite.image, self.quad, -w * vec.x, -h * vec.y, 0, self.flip.x, self.flip.y)
	end
end