include("class")
include("Vector2")
include("Box")

local Class, BaseClass = class.NewClass("Ball", "Box")
Ball = Class

function Class:New()
    BaseClass.New(self)
    
    self.vel = Vector2(100)
    self.players = {}
    self.speed = 100
    self.add = 100
end

function Class:Update(dt)
    if self.position.y < self.size.y * 0.5 or self.position.y > love.graphics.getHeight() - self.size.y * 0.5 then
        self.vel.y = -self.vel.y
    end
    
    for k, v in pairs(self.players) do
        if self:BoxVsBox(v) then
            self.vel = (self.position - v.position):Normalised() * self.speed
            self.speed = self.speed + self.add
        end
    end
    
    self.position = self.position + self.vel * dt
end