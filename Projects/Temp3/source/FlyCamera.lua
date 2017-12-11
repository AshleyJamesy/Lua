local Class = class.NewClass("FlyCamera", "MonoBehaviour")

function Class:Update()
	self.transform.position:Set(self.transform.globalPosition.x, self.transform.globalPosition.y)

	local speed = 100
	if Input.GetKey("lshift") then
		speed = 300
	end

	if Input.GetKey("a") then
		self.transform.position.x = self.transform.position.x - speed * Time.Delta
	end

	if Input.GetKey("d") then
		self.transform.position.x = self.transform.position.x + speed * Time.Delta
	end

	if Input.GetKey("w") then
		self.transform.position.y = self.transform.position.y - speed * Time.Delta
	end

	if Input.GetKey("s") then
		self.transform.position.y = self.transform.position.y + speed * Time.Delta
	end
end