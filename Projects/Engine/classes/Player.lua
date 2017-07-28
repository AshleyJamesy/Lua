local Class = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
	self.spriteRenderer = self:GetComponent("SpriteRenderer")
end

function Class:Update()
	local w, a, s, d = 
		love.keyboard.isDown("w"),
		love.keyboard.isDown("a"),
		love.keyboard.isDown("s"),
		love.keyboard.isDown("d")

	if a or d then
		if a then
			self.spriteRenderer.flip.x = -1
		end

		if d then
			self.spriteRenderer.flip.x = 1
		end

		self.spriteRenderer:PlayAnimation("walk")
	else
		self.spriteRenderer:PlayAnimation("idle")
	end
end