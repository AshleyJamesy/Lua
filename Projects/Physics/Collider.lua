include("class")
include("math/Vector2")

local Class, BaseClass = class.NewClass("Collider")
Collider = Class

function Class:New()
    self.material = "Default"
    self.offset   = Vector2(0, 0)
end

function Class:Draw(x, y)

end