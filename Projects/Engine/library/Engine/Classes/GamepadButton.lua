local Class = class.NewClass("GamepadButton", "MonoBehaviour")

function Class:Awake()
    self.anchor = Vector2(0,0)
    self.radius = 75
    self.colour = Colour(0, 255, 0, 255)
    self.button = "a"
    
    self.sprite = Sprite("resources/ui/shadedLight/36.png")
    
    self.anchor:Set(graphics.getWidth() - 500, graphics.getHeight() - self.radius * 2)
    
    hook.Add("IPointerDownHandler", self, Class.OnPointerDown)
    hook.Add("IPointerUpHandler", self, Class.OnPointerUp)
end

function Class:OnPointerDown(data)
    local vector    = data.position - self.anchor
    local magnitude = vector:Magnitude()
    
    if magnitude <= self.radius then
        hook.Call("GamepadPressed", "virtual", self.button)
    end
end

function Class:OnPointerUp(data)
    hook.Call("GamepadReleased", "virtual", self.button)
end

function Class:RenderUI()
    graphics.draw(self.sprite.image.source, 
        self.sprite.quad, 
        self.anchor.x, 
        self.anchor.y, 
        0, 
        self.radius / self.sprite.image.width * 2.0, 
        self.radius / self.sprite.image.height * 2.0,
        self.sprite.image.width * 0.5, 
        self.sprite.image.height * 0.5
    )
    
    graphics.circle("line", self.anchor.x, self.anchor.y, self.radius)
end