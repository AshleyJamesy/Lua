local Class = class.NewClass("AnimatorState", "Component")

function Class:New(gameObject)
	Class:Base().New(self, gameObject)
	
	self.animation 	= nil
	self.index 		= 1
	self.speed 		= 1.0
	
	self.transitions = {
		
	}
end

function Class:Update()
	if self.animation then

	end
end