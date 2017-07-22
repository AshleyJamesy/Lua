include("class")

local Class, BaseClass = class.NewClass("CircleCollider", "Collider")
CircleCollider = Class

function Class:Awake()
    BaseClass:Awake()
    
    self.radius = 10
end