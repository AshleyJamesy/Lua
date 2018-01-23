local Class = class.NewClass("AnimatorTransition", "Component")

function Class:New(gameObject)
	Class:Base().New(self, gameObject)
	
	self.hasExitTime = true
	
	self.conditions = {
		
	}
end