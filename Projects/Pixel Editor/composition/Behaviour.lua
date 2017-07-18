include("class")
include("composition/Component")

local Class, BaseClass = class.NewClass("Behaviour", "Component")
Behaviour = Class

function Class:New(...)
	BaseClass.New(self, ...)
	
	self.enabled = false
end