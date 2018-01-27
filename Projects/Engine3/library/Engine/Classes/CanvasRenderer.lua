local Class = class.NewClass("CanvasRenderer", "Renderer")

function Class:New()
    Class:Base().New(self, gameObject)
end

function Class:Render(camera)
    for i = #self.transform.children, 1, -1 do
        
    end
end