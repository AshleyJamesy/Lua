local Class = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
	self.spriteRenderer = self:GetComponent("SpriteRenderer")
	self.speed = 100
end

function Class:Update()
	local a = love.keyboard.isDown("a")
	local d = love.keyboard.isDown("d")
	
	if a and d then
		self.spriteRenderer.speed = 1.0
		self.spriteRenderer:PlayAnimation("idle")
	elseif a or d then
		self.spriteRenderer.xflip = a and true or false
		self.spriteRenderer:PlayAnimation("walk")
		self.spriteRenderer.speed = self.speed / 450

		self.transform.position.x = self.transform.position.x + (a and -self.speed or self.speed) * Time.delta
	else
		self.spriteRenderer.speed = 1.0
		self.spriteRenderer:PlayAnimation("idle")
	end
end