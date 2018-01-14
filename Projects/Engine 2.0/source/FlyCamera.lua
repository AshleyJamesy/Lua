local Class = class.NewClass("FlyCamera", "MonoBehaviour")

local function f_distance(x, y, z, w)
	local mx = math.abs(math.sqrt((z - x)^2))
	local my = math.abs(math.sqrt((w - y)^2))
	
	return mx, my
end

local function find_center(x, y, z, w)
	local sx, sy = f_distance(x, y, z, w)
	return math.min(x, z) + sx * 0.5, math.min(y, w) + sy * 0.5
end

function Class:Awake()
	self.scaling 	= false
	self.center 	= Vector2(0,0)
	self.distance 	= 0
	self.zoom 		= 1
	self.speed 		= 100.0
	self.camera 	= self.gameObject:GetComponent("Camera")
end

function Class:Update()
	local speed = self.speed
	if Input.GetKey("lshift") then
		speed = self.speed * 4.0
	end

	if Input.GetKey(self.keys and self.keys[3] or "a") then
		self.transform.position.x = self.transform.position.x - speed * Time.Delta
	end

	if Input.GetKey(self.keys and self.keys[4]  or "d") then
		self.transform.position.x = self.transform.position.x + speed * Time.Delta
	end

	if Input.GetKey(self.keys and self.keys[1]  or "w") then
		self.transform.position.y = self.transform.position.y - speed * Time.Delta
	end

	if Input.GetKey(self.keys and self.keys[2]  or "s") then
		self.transform.position.y = self.transform.position.y + speed * Time.Delta
	end

	if Input.GetMouseButtonDown(1) then
		local x, y = Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y)
	end

	if Input.GetMouseButtonDown(2) then
		local x, y = Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y)
	end
end