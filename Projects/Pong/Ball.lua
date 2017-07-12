include("class")
include("Vector2")
include("Box")
include("Player")

local Class, BaseClass = class.NewClass("Ball", "Box")
Ball = Class

function Class:New()
    BaseClass.New(self)
    
    self.velocity = Vector2(100, 0)
    self.speed = 100
end

function Class:Update(dt)
    self.position = self.position + self.velocity * dt
    
    for k, v in pairs(Player.Players) do
        if Box.BoxVsBox(self, v) then
            log = log .. "collision\n"
            self.speed = self.speed + self.speed * 0.25
            self.velocity = (self.position - v.position):Normalised() * self.speed
        end
    end
end