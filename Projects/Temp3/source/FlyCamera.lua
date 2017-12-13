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
    self.scaling  = false
    self.center   = Vector2(0,0)
    self.distance = 0
    self.zoom     = 1
    
    self.camera = self.gameObject:GetComponent("Camera")
end

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

function Class:Render()
    love.graphics.push()
    love.graphics.origin()
    
    --love.graphics.circle("fill", self.center.x, self.center.y, 20)
    
    love.graphics.pop()
end