local Class = class.NewClass("Renderer", "Component")
Class.Renderers = {
	"SpriteRenderer",
	"Ship"
}

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.bounds 			= Rect(0,0,0,0)
	self.enabled 			= false
	self.isVisible 			= false
	self.sortingOrder 		= 0
end

function Class:Render(camera)
	
end

--OnBecameInvisible is called when the object is no longer visible by any camera.
function Class:OnBecameInvisible(camera)
	
end

--OnBecameVisible is called when the object became visible by any camera.
function Class:OnBecameVisible(camera)
	
end