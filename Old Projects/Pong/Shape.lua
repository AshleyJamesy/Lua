include("class")

local Class, BaseClass = class.NewClass("Shape")
Shape = Class

function Class:New()
    self.material = nil
end