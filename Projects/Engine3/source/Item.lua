local Class = class.NewClass("Item", "MonoBehaviour")

function Class:Awake()
	self.spriteRenderer = self:GetComponent("SpriteRenderer")

	self.name 		= "item"
	self.amount 	= 1
	self.distance 	= 40

	self.inrange 	= false

	hook.Add("PickUp", self, Class.OnPickUp)
end

function Class:OnPickUp(player)
	if (player.transform.globalPosition + Vector2(0, 20) - self.transform.globalPosition):Magnitude() < self.distance then
		Object.Destroy(self.gameObject)
	end

	player:AddItem(self.name, self.amount)
end

function Class:LateUpdate()
	self.inrange 	= false
	local players 	= Object.FindObjectsOfType("Player")
	
	if players then
		for k, v in pairs(players) do
			if (v.transform.globalPosition + Vector2(0, 20) - self.transform.globalPosition):Magnitude() < self.distance then
				self.inrange = true

				v.renderUI = true
			end
		end
	end
	
	if self.inrange then
		self.gameObject.material = Material("Sprite/Outline")
	else
		self.gameObject.material = Material("Sprite/Default")
	end
end