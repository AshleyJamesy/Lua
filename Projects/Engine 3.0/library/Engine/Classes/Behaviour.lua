local Class = class.NewClass("Behaviour", "Component")

function Class:New(gameObject)
	Class:Base().New(self, gameObject)
	
	self.enabled 			= false
	self.isActiveAndEnabled = false
end