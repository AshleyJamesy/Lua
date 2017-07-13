include("class")
include("Vector2")
include("Box")
include("Player")

local Class, BaseClass = class.NewClass("Ball", "Box")
Ball = Class

function Class:New()
    BaseClass.New(self)
    
    self.velocity = Vector2(250, 0)
    self.speed = 250
end

function Class:Update(dt)
    self.position = self.position + self.velocity * dt
    
    for k, v in pairs(Player.Players) do
        if Box.BoxVsBox(self, v) then
            self.speed = self.speed + self.speed * 0.25
            self.velocity = (self.position - v.position):Normalised() * self.speed
        end
    end
    
    if self.position.y > love.graphics.getHeight() - self.size.y * 0.5 or self.position.y < 0 + self.size.y * 0.5 then
        self.velocity.y = -self.velocity.y
    end
end