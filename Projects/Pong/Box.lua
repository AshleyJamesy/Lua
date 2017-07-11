include("class")
include("Vector2")
include("Vector4")

local Class, BaseClass = class.NewClass("Box")
Box = Class

Class.string = "super string"

function Class:New()
    self.position = Vector2()
    self.size = Vector2()
    self.colour = Vector4(0,0,0,255)
end

function Class:BoxVsBox(other)
    local ahx = self.size.x * 0.5
    local bhx = other.size.x * 0.5
    local ahy = other.size.y * 0.5
    local bhy = other.size.y * 0.5
    
    local x = (self.position.x + ahx) > (other.position.x - bhx) and
              (self.position.x - ahx) < (other.position.x + bhx)
    local y = (self.position.y + ahy) > (other.position.y - bhy) and
              (self.position.y - ahy) < (other.position.y + bhy)

    return x and y
end

function Class:Draw()
    love.graphics.setColor(self.colour.x, self.colour.y, self.colour.z, self.colour.w)
    love.graphics.rectangle("fill", self.position.x - self.size.x * 0.5, self.position.y - self.size.y * 0.5, self.size.x, self.size.y)
end