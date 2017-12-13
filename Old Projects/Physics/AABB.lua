include("class")
include("math/Vector2")

local Class, BaseClass = class.NewClass("AABB", "Collider")
AABB = Class

function AABB:New(a, b)
    self.min = Vector2(a)
    self.max = Vector2(b)
end