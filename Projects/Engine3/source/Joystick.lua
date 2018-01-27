local Class = class.NewClass("Joystick", "MonoBehaviour")

function Class:Awake()
    self.min = 50
    self.max = 200
    self.origin = Vector2(0,0)
end

function Class:Update()
    
end

function Class:RenderUI()
    graphics.setColor(255, 255, 255, 100)
    graphics.circle("fill", self.origin.x, self.origin.y, self.max)
end