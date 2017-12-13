local Class = class.NewClass("SpriteRenderer", "Renderer")

SpriteDrawMode = enum{
	"Simple", 	--Displays the full sprite.
	"Sliced",	--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will scale.
	"Tiled"		--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will tile.
}

local s = Sprite("resources/sprites/hero.png")
s:NewFrame(16, 16, 16, 16)
s:NewFrame(32, 16, 16, 16)
s:NewFrame(48, 16, 16, 16)
s:NewFrame(64, 16, 16, 16)
s:NewFrame(80, 16, 16, 16)
s:NewFrame(96, 16, 16, 16)

s:NewFrame(16, 32, 16, 16)
s:NewFrame(32, 32, 16, 16)
s:NewFrame(48, 32, 16, 16)
s:NewFrame(64, 32, 16, 16)
s:NewFrame(80, 32, 16, 16)
s:NewFrame(96, 32, 16, 16)

s:NewFrame(16, 48, 16, 16)
s:NewFrame(32, 48, 16, 16)
s:NewFrame(48, 48, 16, 16)
s:NewFrame(64, 48, 16, 16)
s:NewFrame(96, 48, 16, 16)

s:NewFrame(16, 64, 16, 16)
s:NewFrame(32, 64, 16, 16)
s:NewFrame(48, 64, 16, 16)
s:NewFrame(64, 64, 16, 16)
s:NewFrame(80, 64, 16, 16)
s:NewFrame(96, 64, 16, 16)

s:NewFrame(16, 80, 16, 16)
s:NewFrame(32, 80, 16, 16)
s:NewFrame(48, 80, 16, 16)
s:NewFrame(64, 80, 16, 16)
s:NewFrame(80, 80, 16, 16)
s:NewFrame(96, 80, 16, 16)

s:NewAnimation("idle", Animation(1.0, true, { 1, 2, 3, 4}))

local default = Sprite("resources/engine/default.png")
function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.colour 	= Colour(255,255,255,255)
	self.drawMode 	= SpriteDrawMode.None
	self.flipX 		= false
	self.flipY 		= false
	self.sprite 	= s

	--animation
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.playing			= false

	self.hash = self.gameObject.layer ^ 17 + self.sortingOrder ^ 17
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
    self.hash = self.gameObject.layer ^ 17 + self.sortingOrder ^ 17
    
    local sprite = self.sprite
    if sprite then
		local animation = sprite:GetAnimation(self.animation)
		
		if animation then
			self.timer = self.timer - (Time.Delta * self.speed)

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
			end
		end
end

function Class:Render(camera)
 local sprite = self.sprite
		
	local frame = sprite:GetFrame(self.animation_index)
	sprite.quad:setViewport(frame.x, frame.y, frame.w, frame.h)
		
		local transform = self.transform
		local scale 	= transform.globalScale
		local position 	= transform.globalPosition
		local rotation 	= transform.globalRotation
		
		local x, y, w, h = sprite.quad:getViewport()
		
		self.bounds:Set(position.x - w * 0.5 * scale.x, position.y - h * 0.5 * scale.y, w * scale.x, h * scale.y)
		
		if Rect.Intersect(camera.bounds, self.bounds) then
			love.graphics.setColor(self.colour:Unpack())
			love.graphics.draw(sprite.source, 
					sprite.quad, 
					position.x, 
					position.y, 
					rotation, 
					scale.x * (self.flipX and -1 or 1), 
					scale.y * (self.flipY and -1 or 1),
					w * 0.5, 
					h * 0.5
			)
		end
		end
end

local function sort(a, b)
	return a.hash == b.hash and (a.__id < b.__id) or (a.hash < b.hash)
end

local function PreRender()
	local group = SceneManager:GetActiveScene().__objects["SpriteRenderer"]
	if group then
		table.sort(group, sort)
	end
end
hook.Add("OnPreRender", "SpriteRenderer", PreRender)