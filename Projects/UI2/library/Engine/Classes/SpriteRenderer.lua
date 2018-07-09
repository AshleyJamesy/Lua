local Class = class.NewClass("SpriteRenderer", "Renderer")

local graphics = love.graphics

SpriteDrawMode = enum{
	"Simple", 	--Displays the full sprite.
	"Sliced",	--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will scale.
	"Tiled"		--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will tile.
}

SpriteTotal = 0 

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.colour 	= Colour(1, 1, 1, 1)
	
	self.drawMode 	= SpriteDrawMode.None

	self.sprite 	= nil
	self.flipX 		= false
	self.flipY 		= false
	
	--animation
	self.speed 				= 1.0
	self.index 				= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.playing			= false
	
	self.material = nil
end

function Class:ResetAnimation(name)
	local sprite 	= self.sprite
	local animation = sprite:GetAnimation(name or self.animation)

	self.index = 1
	self.timer = 1 / animation.fps
	
	local frame = sprite:GetFrame(1)
	
	sprite.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
end

function Class:PlayAnimation(name)
	if self.animation == name then
	else
		if self.sprite then
			if self.sprite:GetAnimation(name) then
				self.animation = name
				self.playing = true
				self:ResetAnimation()
			end
		end
	end
end

function Class:StopAnimation()
	self.animation = ""
end

function Class:Update()
 SpriteTotal = SpriteTotal + 1
 
	local sprite = self.sprite
	if sprite then
		local animation = sprite:GetAnimation(self.animation)
		
		if animation then
			self.timer = self.timer - (Time.Delta * self.speed)
			
			if self.timer <= 0 then
				self.index 	= self.index + 1
				self.timer 				= 1 / animation.fps
				
				if self.index > #animation.frames then
					if animation.loop then
						self.index = 1
					else
						self.index 	= #animation.frames
						self.playing 			= false
					end
				end
			end
		end
	end
end

local animation, frame, transform, scale, position, rotation

SpriteCount = 0

function Class:Render(camera)
 if camera.cameraType == CameraType.Game then
     SpriteCount = SpriteCount + 1
 end
 
	local sprite = self.sprite
	if sprite then
	 animation 	= sprite:GetAnimation(self.animation)
		frame 		  = sprite:GetFrame(animation and animation.frames[self.index] or 1)
		transform 	= self.transform
		scale 		  = transform.globalScale
		position 		= transform.globalPosition
		rotation 		= transform.globalRotation
		
		local pixel_scale 	= 100 / sprite.pixelPerUnit
		
		sprite.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
		
		graphics.setColor(self.colour:GetTable())
		
		if self.material then
		    self.material:Use()
		else
		    Material:Reset()
		end
		
		graphics.draw(sprite.image.source, sprite.quad, self.transform.__cTransform)
 end
end

function Class:OnDrawGizmos(camera)
		graphics.setColor(255,255,255,125)
		
		--[[
		graphics.print(
		math.ceil(self.transform.globalPosition.x/self.scene.hashUnit) .. "x" ..
		math.ceil(self.transform.globalPosition.y/self.scene.hashUnit) .. "\n" ..
		string.format("x:%0.2f\n", self.transform.globalPosition.x) ..
	 string.format("y:%0.2f\n", self.transform.globalPosition.y)
		,
		self.transform.globalPosition.x + 15, 
		self.transform.globalPosition.y
		)
		]]
		
		graphics.setColor(75,75,255,255)
		--love.graphics.circle("fill", bounds.x, bounds.y, 5)
		--love.graphics.circle("fill", bounds.x + bounds.w, bounds.y, 5)
		--love.graphics.circle("fill", bounds.x + bounds.w, bounds.y + bounds.h, 5)
		--love.graphics.circle("fill", bounds.x, bounds.y + bounds.h, 5)
end