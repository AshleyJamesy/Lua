include("class")
include("composition/components/Sprite")
include("composition/MonoBehaviour")
include("types/Colour")

local Class, BaseClass = class.NewClass("SpriteRenderer", "MonoBehaviour")
SpriteRenderer = Class
SpriteRenderer.sort =  function(a, b)
	return a.sortingIndex > b.sortingIndex
end

function Class:Awake()
	self.sortingIndex	= 0
	self.fps 			= 12.0
	self.xflip	 		= false
	self.speed 			= 1.0
	self.timer 			= 1 / self.fps
	self.frame 			= 1
	self.colour 		= Colour(255,255,255,255)
	self.sprite 		= Sprite(git .. "resources/sprites/hero.png")

	local w, h 	= self.sprite.image:getDimensions()

	table.insert(self.sprite.frames, {x=16,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=32,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=48,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=64,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=80,y=32,w=16,h=16})
	table.insert(self.sprite.frames, {x=96,y=32,w=16,h=16})

	self.quad = love.graphics.newQuad(self.sprite.frames[1].x, self.sprite.frames[1].y, self.sprite.frames[1].w, self.sprite.frames[1].h, w, h)

	self.rigidBody = self:GetComponent("RigidBody")

	self.transform.scale:Set(1,1)

	print("sprite renderer awake")
end

function Class:JoystickAxis(joystick, axis, value)
if self.rigidBody then
	if axis == 1 then
		if math.abs(value) > 0.1 then
			if value > 0.1 then
				self.xflip = false
			end

			if value < 0.1 then
				self.xflip = true
			end

			self.rigidBody.velocity.x = value * 4
			self.speed = 1 * math.abs(value)
		else
			self.rigidBody.velocity.x = 0
			self.speed = 0
		end
	end
	end
end

function Class:PlayAnimation(animation_name)
	
end

function Class:Render()
	self.timer = self.timer - (Time.delta * self.speed)
	if self.timer <= 0 then
		self.frame = self.frame + 1
		self.timer = 1 / self.fps

		if self.frame > #self.sprite.frames then 
			self.frame = 1 
		end

		self.quad:setViewport(self.sprite.frames[self.frame].x, self.sprite.frames[self.frame].y, self.sprite.frames[self.frame].w, self.sprite.frames[self.frame].h)
	end

	local x, y, w, h = self.quad:getViewport()
	love.graphics.setColor(self.colour:Unpack())
	love.graphics.draw(self.sprite.image, self.quad, -w * self.sprite.pivot.x * (self.xflip and -1 or 1), -h * self.sprite.pivot.y, 0, self.xflip and -1 or 1, 1)
end