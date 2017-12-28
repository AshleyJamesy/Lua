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
	
	self.camera 	= self.gameObject:GetComponent("Camera")
end

function Class:Update()
	self.transform.position:Set(self.transform.globalPosition.x, self.transform.globalPosition.y)

	local speed = 100
	if Input.GetKey("lshift") then
		speed = 300
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
	
	if Input.GetMouseButton(1) then
		local object = GameObject()
		local sr = object:AddComponent("SpriteRenderer")
		sr.sprite 	= Sprite("resources/sprites/hero.png")
		sr.emission = Sprite("resources/sprites/hero_gray.png")
		object.transform.position:Set(Camera.main:ScreenToWorld(Input.GetMousePosition()))
	end
 
	local wx, wy = Input.GetMouseWheel()

	local zoom = Camera.main.zoom
	--zoom.x = zoom.x - wy * 0.1
	--zoom.y = zoom.y - wy * 0.1

	if Application.Mobile then
		if self.camera then
			if not self.scaling then
				if Input.GetTouch(1) and Input.GetTouch(2) then
					self.scaling = true
					local ax, ay = Input.GetTouchPosition(1)
					local bx, by = Input.GetTouchPosition(2)

					self.distance = f_distance(ax, ay, bx, by)
					self.center:Set(find_center(ax, ay, bx, by))
					self.z = self.zoom
				else
				    if Input.GetTouchDown(1) then
				        local object = GameObject()
				        local sr = object:AddComponent("SpriteRenderer")
				        sr.sprite 	= Sprite("resources/sprites/hero.png")
				        sr.emission = Sprite("resources/sprites/hero_gray.png")
				        object.transform.position:Set(Camera.main:ScreenToWorld(Input.GetMousePosition()))
				    end
				end
			else
				if Input.GetTouchMoved(1) or Input.GetTouchMoved(2) then
					local ax, ay = Input.GetTouchPosition(1)
					local bx, by = Input.GetTouchPosition(2)

					local d = f_distance(ax, ay, bx, by)
					self.zoom = self.z * (self.distance / d)
					self.center:Set(find_center(ax, ay, bx, by))

					D = self.zoom
					self.camera.zoom:Set(self.zoom, self.zoom)
				end

				if Input.GetTouchUp(1) or Input.GetTouchUp(2) then
					self.scaling = false
				end
			end
		end
	end
end