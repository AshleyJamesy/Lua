local Class = class.NewClass("SpriteRenderer", "Renderer")

SpriteDrawMode = enum{
	"Simple", 	--Displays the full sprite.
	"Sliced",	--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will scale.
	"Tiled"		--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will tile.
}

local default = Sprite("resources/engine/default.png")
function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.colours 	= {
		diffuse 	= Colour(255,255,255,255),
		emission 	= Colour(math.random() * 255, math.random() * 255, math.random() * 255, math.random() * 255)
	}
	
	self.drawMode 	= SpriteDrawMode.None
	self.flipX 		= false
	self.flipY 		= false
	
	self.sprite 	= default
	self.emission 	= nil
	
	--animation
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= "idle"
	self.playing			= false
	
	self.hash 				= self.gameObject.layer ^ 17 + self.sortingOrder ^ 17
end

function Class:ResetAnimation(name)
	local sprite 	= self.sprite
	local animation = sprite:GetAnimation(name or self.animation)

	self.animation_index = 1
	self.timer 			 = 1 / animation.fps
	
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
 self.a = self.transform.position.x
 
	self.hash = self.gameObject.layer ^ 17 + self.sortingOrder ^ 17

	local sprite = self.sprite
	if sprite then
		local animation = sprite:GetAnimation(self.animation)
		
		if animation then
			self.timer = self.timer - (Time.Delta * self.speed)

			if self.timer <= 0 then
				self.animation_index 	= self.animation_index + 1
				self.timer 				= 1 / animation.fps

				if self.animation_index > #animation.frames then
					if animation.loop then
						self.animation_index = 1
					else
						self.animation_index 	= #animation.frames
						self.playing 			= false
					end
				end
			end
		end
	end
end

function Class:Render(camera)
	local sprite = self.sprite
	if sprite then
		local attributes 	= sprite.attributes
		local frame 		= sprite:GetFrame(self.animation_index)
		local transform 	= self.transform
		local scale 		= transform.globalScale
		local position 		= transform.globalPosition
		local rotation 		= transform.globalRotation
		
		local pixel_scale 	= 100 / sprite.pixelPerUnit
		
		self.gameObject:SetBounds(
			position.x - (frame.w * 0.5 * scale.x) * pixel_scale, 
			position.y - (frame.h * 0.5 * scale.y) * pixel_scale, 
			frame.w * scale.x * pixel_scale, 
			frame.h * scale.y * pixel_scale)

		if Rect.Intersect(camera.bounds, self.gameObject.__bounds) then
			self.isVisible = true
			
			sprite.quad:setViewport(frame.x, frame.y, frame.w, frame.h)

			if self.emission then
				Shader("resources/shaders/material.glsl"):Send("emission", self.emission.image.source)
				Shader("resources/shaders/material.glsl"):SendColour("emission_colour", { self.colours.emission:Unpack() })
			end

			graphics.setColor(self.colours.diffuse:Unpack())
			
			graphics.draw(self.sprite.image.source, 
				sprite.quad, 
				position.x, 
				position.y, 
				rotation, 
				scale.x * (self.flipX and -1 or 1) * pixel_scale, 
				scale.y * (self.flipY and -1 or 1) * pixel_scale,
				frame.w * 0.5, 
				frame.h * 0.5
			)
		else
			self.isVisible = false
		end
	end
end

function Class:OnDrawGizmosSelected(camera)
	local bounds = self.gameObject.__bounds
	if Rect.Intersect(camera.bounds, bounds) then
		graphics.setColor(255,255,255,125)
		graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h)
		
		graphics.setColor(75,75,255,255)
		--love.graphics.circle("fill", bounds.x, bounds.y, 5)
		--love.graphics.circle("fill", bounds.x + bounds.w, bounds.y, 5)
		--love.graphics.circle("fill", bounds.x + bounds.w, bounds.y + bounds.h, 5)
		--love.graphics.circle("fill", bounds.x, bounds.y + bounds.h, 5)
	end
end

local function sort(a, b)
	return a.hash == b.hash and (a.__id < b.__id) or (a.hash < b.hash)
end

function Class:PreRender(camera)
	local group = SceneManager:GetActiveScene().__objects["SpriteRenderer"]
	if group then
		table.sort(group, sort)
	end
	
    Shader("resources/shaders/material.glsl"):Use()
end

function Class:PostRender(camera)
    Shader("resources/shaders/material.glsl"):Default()
end