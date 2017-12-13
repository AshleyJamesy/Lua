include("class")
include("Box")

local Class, BaseClass = class.NewClass("Player", "Box")
Player = Class

Class.Players = {}

function Class:New()
    BaseClass.New(self)
    
    self.score = 0
    self.touch = nil
    self.target = Vector2()
    
    table.insert(Class.Players, self)
end

function Class:Update(dt)
    self.position = Vector2.Lerp(self.position, self.target, dt * 2)
end