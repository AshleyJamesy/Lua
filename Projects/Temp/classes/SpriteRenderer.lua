local Class = class.NewClass("SpriteRenderer")

function Class:New(sprite)
	self.sprite = sprite
	
	--animation
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.animations 		= {}
	self.playing			= false

	--graphics
	self.xflip 			= false
	self.yflip			= false
	self.colour 		= Colour(255,255,255,255)
	self.order 			= 1

	local w, h 	= self.sprite.attributes.diffuse.width, self.sprite.attributes.diffuse.height
	self.quad 	= love.graphics.newQuad(0, 0, w, h, w, h)
	
	if self.sprite.frames[1] then
		local frame = self.sprite.frames[1]
		self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
	end
end

function Class:Render()
	love.graphics.push()
	--love.graphics.translate(self.gameObject.position.x, self.gameObject.position.y)

	if self.sprite and self.quad then
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
						self.playing 			= false
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

		--Drawing
		love.graphics.setCanvas(love.graphics.canvases.colour)
		love.graphics.draw(self.sprite.attributes.diffuse.source, self.quad, -w * self.sprite.pivot.x * xf, -h * self.sprite.pivot.y * yf, 0, xf, yf)
		love.graphics.setCanvas()
	else
		if self.sprite and not self.quad then
			local w, h = self.sprite.image.width, self.sprite.image.height
			self.quad = love.graphics.newQuad(0, 0, w, h, w, h)

			if self.sprite.frames[1] then
				local frame = self.sprite.frames[1]
				self.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
			end
		end
	end

	love.graphics.pop()
end