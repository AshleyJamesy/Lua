include("class")
include("Vector2")
include("Vector4")

local Class, BaseClass = class.NewClass("Box")
Box = Class

function Class:New()
    self.position = Vector2()
    self.size = Vector2()
    self.colour = Vector4(0,0,0,255)
end

function Class.BoxVsBox(a, b)
    local ah = a.size * 0.5
    local bh = b.size * 0.5
    
    local x = (a.position.x + ah.x) > (b.position.x - bh.x) and
              (a.position.x - ah.x) < (b.position.x + bh.x)
    local y = (a.position.y + ah.y) > (b.position.y - bh.y) and
              (a.position.y - ah.y) < (b.position.y + bh.y)
    
    return x and y
end

function Class:Draw()
    love.graphics.setColor(self.colour.x, self.colour.y, self.colour.z, self.colour.w)
    love.graphics.rectangle("line", self.position.x - self.size.x * 0.5, self.position.y - self.size.y * 0.5, self.size.x, self.size.y)
    love.graphics.line(self.position.x - self.size.x * 0.5, self.position.y, self.position.x + self.size.x * 0.5, self.position.y)
    love.graphics.line(self.position.x, self.position.y - self.size.y * 0.5, self.position.x, self.position.y + self.size.y * 0.5)
end