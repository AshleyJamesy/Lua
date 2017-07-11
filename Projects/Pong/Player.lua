include("class")
include("Box")

local Class, BaseClass = class.NewClass("Player", "Box")
Player = Class

function Class:New()
    BaseClass.New(self)
    
    self.score = 0
    self.touch = nil
end