local Class = class.NewClass("RectTransform", "Transform")

function Class:New(gameObject, x, y)
	Class:Base().New(self, gameObject, x, y)
	
	self.anchor = Vector2(0, 0)
	
	self.gameObject.transform 		= self
	self.gameObject.components[1] 	= self
end