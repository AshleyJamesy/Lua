local Class = class.NewClass("SpriteRenderer", "MonoBehaviour")

function Class:Awake(...)
	self.sortingIndex 		= 0
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.playing 			= false
	self.xflip 				= false
	self.yflip 				= false
	self.colour 			= Colour(255)
	self.sprite 			= Sprite(...)

	self.batchid 			= -1
	
	self:SetSprite(self.sprite)
end

function Class:SetViewport(x,y,w,h)
	self.quad:setViewport(x, y, w, h)

	self.gameObject.__aabb.w = self.transform.scale.x * w
	self.gameObject.__aabb.h = self.transform.scale.y * h
end

function Class:SetSprite(sprite)
	if sprite then
		self.sprite = sprite
		
		local w, h 	= self.sprite.image:GetDimensions()
		self.quad 	= love.graphics.newQuad(0, 0, w, h, w, h)

		local frame = self.sprite:GetFrame(1)
		
		if frame then
			self:SetViewport(frame.x, frame.y, frame.w, frame.h)
		end
	end
end

function Class:Reset(name)
	local animation = self.sprite:GetAnimation(name or self.animation)

	self.animation_index = 1
	self.timer 			 = 1 / animation.fps
	
	local frame = self.sprite:GetFrame(animation.frames[1])
	
	self:SetViewport(frame.x, frame.y, frame.w, frame.h)
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
				
				self:SetViewport(frame.x, frame.y, frame.w, frame.h)
			end
		end
	end
end

function Class:Render()
	if self.sprite then
		local x, y, w, h = self.quad:getViewport()
		
		local xf = (self.xflip and -1 or 1) * self.transform.scale.x
		local yf = (self.yflip and -1 or 1) * self.transform.scale.y

		--love.graphics.setColor(self.colour:Unpack())

		--love.graphics.draw(self.sprite.image.source, self.quad, 
		--	self.transform.globalPosition.x,
		--	self.transform.globalPosition.y, self.transform.globalRotation, xf, yf, w * self.sprite.pivot.x, h * self.sprite.pivot.y)
		
		self.sprite:Render(self.quad, 
			self.transform.globalPosition.x, 
			self.transform.globalPosition.y, 
			self.transform.globalRotation,
			xf, yf, w * self.sprite.pivot.x, h * self.sprite.pivot.y, self.colour)
	end
end