local Class = class.NewClass("ShapeRenderer", "Renderer")

function Class:New()
    Class:Base().New(self, gameObject)
end

function Class:Render(camera)
    love.graphics.circle("fill", self.transform.position.x, self.transform.position.y, 5)
end