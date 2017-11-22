local Class = class.NewClass("Renderer", "Component")

function Class:New()
	Class:Base().New(self)

	self.bounds 			= nil
	self.enabled 			= false
	self.isVisible 			= false
	self.sortingLayerID 	= 0
	self.sortingLayerName 	= ""
	self.sortingOrder 		= 0
end

function Class:OnBecameInvisible()

end

function Class:OnBecameVisible()
	
end