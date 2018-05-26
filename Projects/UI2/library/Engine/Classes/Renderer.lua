local Class = class.NewClass("Renderer", "Component")
Class.Renderers = {
    "SpriteRenderer",
    "CanvasRenderer",
    "ShapeRenderer"
}

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.bounds 			= Rect(0,0,0,0)
	self.enabled 			= false
	self.isVisible 			= false
	self.sortingOrder 		= 0
end

function Class.Batch()
 local scene = SceneManager.activeScene
 local objects = SceneManager.activeScene.__objects
 
 for k, v in pairs(Class.Renderers) do
     if objects[v] then
         for i, j in pairs(objects[v]) do
             local bounds = j.transform.bounds
	            scene.__hash:Add(bounds.x, bounds.y, bounds.w, bounds.h, 100, j)
         end
     end
 end
end

function Class:Render(camera)
	
end

function Class:RenderUI(camera)
    
end

--OnBecameInvisible is called when the object is no longer visible by any camera.
function Class:OnBecameInvisible(camera)
	
end

--OnBecameVisible is called when the object became visible by any camera.
function Class:OnBecameVisible(camera)
	
end