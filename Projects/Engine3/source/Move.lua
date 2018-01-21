local Class = class.NewClass("Move", "MonoBehaviour")

function Class:Awake()
	self.speed = 150.0
	self.spriteRenderer = self:GetComponent("SpriteRenderer")

	self.seek 	= false
	self.target = Vector2(0, 0)
end

local mouse = Vector2(0, 0)
function Class:Update()
	mouse:Set(Camera.main:MousePosition())
	local displacement = (mouse - self.transform.position):Normalised()
	local angle = math.deg(displacement:ToAngle())

	if angle > 90 or angle < -90 then
		self.spriteRenderer.flipX = false
	else
		self.spriteRenderer.flipX = true
	end
	
	if Input.GetMouseButtonDown(1) then
		self.seek = true
		self.target:Set(mouse.x, mouse.y)
	end
	
	if self.seek then
		local a = (self.target - self.transform.position + Vector2(0, -40))
		local n = a:Normalised()
		self.transform.position.x = self.transform.position.x + n.x * self.speed * Time.Delta
		self.transform.position.y = self.transform.position.y + n.y * self.speed * Time.Delta

		self.spriteRenderer:PlayAnimation("run")
		self.spriteRenderer.speed = self.speed / 90.0
		
		if a:Magnitude() < 1.0 then
			self.seek = false
			self.target:Set(0, 0)
			self.spriteRenderer:PlayAnimation("idle")
			self.spriteRenderer.speed = 1.0
		end
	end

	if Input.GetKey("w") or Input.GetKey("s") then
		if Input.GetKey("w") then
			self.transform.position.y = self.transform.position.y - self.speed * Time.Delta
		end

		if Input.GetKey("s") then
			self.transform.position.y = self.transform.position.y + self.speed * Time.Delta
		end
	end

	if Input.GetKey("a") or Input.GetKey("d") then
		if Input.GetKey("a") and Input.GetKey("d") then
		else
			if Input.GetKey("a") then
				self.transform.position.x = self.transform.position.x - self.speed * Time.Delta
			end

			if Input.GetKey("d") then
				self.transform.position.x = self.transform.position.x + self.speed * Time.Delta
			end
		end
	end

	if Input.GetKey("w") or Input.GetKey("a") or Input.GetKey("s") or Input.GetKey("d") then
		self.seek = false
		self.target:Set(0, 0)

		if Input.GetKey("a") and Input.GetKey("d") and not Input.GetKey("w") and not Input.GetKey("s") then
			self.spriteRenderer:PlayAnimation("idle")
			self.spriteRenderer.speed = 1.0
		else
			if self.spriteRenderer.animation ~= "run" then
				self.spriteRenderer:PlayAnimation("run")
				self.spriteRenderer.speed = self.speed / 90.0
			end
		end
	else
		if not self.seek then
			self.spriteRenderer:PlayAnimation("idle")
			self.spriteRenderer.speed = 1.0
		end
	end
end