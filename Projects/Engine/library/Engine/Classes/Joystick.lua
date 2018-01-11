local Class = class.NewClass("Joystick", "MonoBehaviour")

function Class:Awake()
    self.id       = 0
    self.anchor   = Vector2(0,0)
    self.position = Vector2(0,0)
    self.radius   = 150
    self.deadzone = 0
    
    self.background = Sprite("resources/ui/shadedLight/01.png")
    self.handle     = Sprite("resources/ui/shadedLight/11.png")
    
    self.anchor:Set(self.radius + 80, graphics.getHeight() - self.radius - 50)
    
    hook.Add("IPointerDownHandler", self, Class.OnPointerDown)
    hook.Add("IPointerUpHandler", self, Class.OnPointerUp)
    hook.Add("IDrag", self, Class.OnDrag)
    
    hook.Call("JoystickAdded", "virtual")
end

function Class:OnPointerDown(data)
    if self.id == 0 then
        local vector    = data.position - self.anchor
        local magnitude = vector:Magnitude()
        local normal    = vector:Normalised()
        	
        if magnitude <= self.radius then
            self.id = data.id
            
            hook.Call("JoystickAxis", "virtual", 1, normal.x)
            hook.Call("JoystickAxis", "virtual", 2, normal.y)
            
            if magnitude > self.deadzone then
                self.position:Set(vector.x, vector.y)
            else
                local normal = vector:Normalised() * (self.radius - self.deadzone)
                self.position:Set(normal.x, normal.y)
            end
        end
    end
end

function Class:OnDrag(data)
    if self.id == data.id then
        local vector    = data.position - self.anchor
        local magnitude = vector:Magnitude()
        local normal    = vector:Normalised()
        
        hook.Call("JoystickAxis", "virtual", 1, normal.x)
        hook.Call("JoystickAxis", "virtual", 2, normal.y)                
            
        if magnitude >= self.deadzone and magnitude <= self.radius then
                self.position:Set(vector.x, vector.y)
        else
            local normal = vector:Normalised() * (self.radius - self.deadzone)
            self.position:Set(normal.x, normal.y)
        end
    end
end

function Class:OnPointerUp(data)
    if self.id == data.id then
        self.id = 0
        self.position:Set(0,0)
        
        hook.Call("JoystickAxis", "virtual", 1, 0)
        hook.Call("JoystickAxis", "virtual", 2, 0) 
    end
end

function Class:RenderUI()
    local magnitude = math.clamp(self.position:Magnitude(), self.deadzone, self.radius * 0.5)
    local normal    = self.position:Normalised()
    
    graphics.draw(self.background.image.source, 
        self.background.quad, 
        self.anchor.x, 
        self.anchor.y, 
        0, 
        self.radius / self.background.image.width * 2.0, 
        self.radius / self.background.image.height * 2.0,
        self.background.image.width * 0.5, 
        self.background.image.height * 0.5
    )
    
    graphics.draw(self.handle.image.source, 
        self.handle.quad, 
        self.anchor.x + (normal.x * magnitude), 
        self.anchor.y + (normal.y * magnitude), 
        0, 
        (self.radius - self.deadzone) * 0.5 / self.handle.image.width * 2.0, 
        (self.radius - self.deadzone) * 0.5 / self.handle.image.height * 2.0,
        self.handle.image.width * 0.5, 
        self.handle.image.height * 0.5
    )
    
    --graphics.circle("line", self.anchor.x, self.anchor.y, self.radius)
    --graphics.circle("line", self.anchor.x, self.anchor.y, self.deadzone)
    --graphics.circle("fill", 
    --    self.anchor.x + (normal.x * magnitude),
    --    self.anchor.y + (normal.y * magnitude),
    --    math.clamp(self.radius - (self.radius - self.deadzone), self.radius * 0.5, self.radius)
    --)
end