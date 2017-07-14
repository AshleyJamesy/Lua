include("class")

local Class, BaseClass = class.NewClass("Circle", "Collider")
Circle = Class

function Class:New(radius)
    BaseClass.New(self)
    self.radius = TypeOf(radius) == "number" and radius or 0
end

function Class:Draw(x, y)
    if TypeOf(x) ~= "number" then
        y = x.y
        x = x.x
    end
    
    love.graphics.circle("line", x + self.offset.x, y + self.offset.y, self.radius)
end