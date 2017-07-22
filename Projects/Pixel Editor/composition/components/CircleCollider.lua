include("class")

local Class, BaseClass = class.NewClass("CircleCollider", "Collider")
CircleCollider = Class

function Class:Awake()
    BaseClass:Awake()
    
    self.radius = 30
end

function Class:Render()
    love.graphics.setColor(0,255,0,255)
    love.graphics.circle("line", self.offset.x, self.offset.y, self.radius)
end