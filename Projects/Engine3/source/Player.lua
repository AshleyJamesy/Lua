local Class = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
	self.speed = 150.0
	self.spriteRenderer = self:GetComponent("SpriteRenderer")
	
	self.animation 	= "idle"

	self.inventory = {

	}

	self.renderUI 	= false

	self.pickedUp 	= false
end

function Class:AddItem(item, amount)
	if self.inventory[item] == nil then
		self.inventory[item] = 0
	end

	self.inventory[item] = self.inventory[item] + amount
end

function Class:Update()
	self.renderUI = false

	local aimVector = (Vector2(Camera.main:MousePosition()) - self.transform.position):Normalised()
	local angle = math.deg(aimVector:ToAngle())

	if angle > 0 and angle < 180 then
		self.spriteRenderer.flipX = false
	else
		self.spriteRenderer.flipX = true
	end

	local w, a, s, d = Input.GetKey("w"), Input.GetKey("a"), Input.GetKey("s"), Input.GetKey("d")
	if w or a or s or d then
		if w or s then
			if w then self.transform.position.y = self.transform.position.y - self.speed * Time.Delta end
			if s then self.transform.position.y = self.transform.position.y + self.speed * Time.Delta end
		end

		if a or d then
			if a then self.transform.position.x = self.transform.position.x - self.speed * Time.Delta end
			if d then self.transform.position.x = self.transform.position.x + self.speed * Time.Delta end
		end

		if self.spriteRenderer.animation == "pickup" then
			self.pickedUp  = false
		end

		self.animation = "run"
	else
		if self.spriteRenderer.animation ~= "pickup" then
			self.animation = "idle"
		end
	end

	if Input.GetKeyDown("f") then
		self.animation = "pickup"
	end

	if self.spriteRenderer.animation == "pickup" then
		if self.spriteRenderer.playing then
			if not self.pickedUp and self.spriteRenderer.index == 5 then
				self.pickedUp = true
				hook.Call("PickUp", self)
			end
		else
			self.animation = "idle"
			self.pickedUp  = false
		end
	end

	self.spriteRenderer:PlayAnimation(self.animation)
end

function Class:RenderButtons()
	if self.renderUI then
		graphics.draw(Image("resources/engine/ui/A.png").source, self.transform.globalPosition.x - 50, self.transform.globalPosition.y + 50, 0, 3.0, 3.0)
	end
end