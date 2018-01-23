local Class = class.NewClass("Animator", "Component")

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.current 	= ""
	self.nodes 		= {}
end

