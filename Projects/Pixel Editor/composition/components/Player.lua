include("class")

local Class, BaseClass = class.NewClass("Player", "MonoBehaviour")
Player = Class

function Class:Awake()
	self.rigidBody 		= self:GetComponent("RigidBody")
	self.spriteRenderer = self:GetComponent("SpriteRenderer")
	self.particleSystem = self:GetComponent("ParticleSystem")
	self.swimming = true
	self.speed = Vector2(0,0)
end

function Class:Update()
	self.transform.rotation = (Camera.main:ToWorld(love.mouse.getPosition()) - self.transform.position):Normalised():ToAngle()

	local degrees = math.deg(self.transform.rotation)
	if degrees > 90 and degrees < 270 then
		self.spriteRenderer.yflip = true
	else
		self.spriteRenderer.yflip = false
	end

	local w = love.keyboard.isDown("w")
	if w or love.mouse.isDown(1) then
		self.speed = -self.transform:Right()
	end

	self.speed 					= self.speed * 0.99
	self.rigidBody.velocity 	= self.speed + Vector2(0, 0.5)
	self.spriteRenderer.speed 	= self.speed:Magnitude() + 0.5

	if self.swimming then
		self.spriteRenderer:PlayAnimation("swim")
	else
		if aDown or dDown then
			self.spriteRenderer:PlayAnimation("walk")
		else
			self.spriteRenderer:PlayAnimation("idle")
		end
	end

	self.particleSystem.offset = self.transform:Right() * -27 + self.transform:Up() * -2.8

	Camera.main.transform.position = Vector2.Lerp(Camera.main.transform.position, self.transform.position, Time.delta * 2.0)
end