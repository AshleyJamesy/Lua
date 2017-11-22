local Class = class.NewClass("Behaviour", "Component")

function Class:New()
	Class:Base().New(self)

	self.enabled 			= false
	self.isActiveAndEnabled = false
end