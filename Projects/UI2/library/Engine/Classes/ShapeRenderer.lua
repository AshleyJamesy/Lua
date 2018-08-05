local Class = class.NewClass("ShapeRenderer", "Renderer")

local quad = Image("resources/engine/albedo.png")

function Class:New()
    Class:Base().New(self, gameObject)
    
    self.width = 100
    self.height = 100
    self.offset = Vector2(50, 50)
    
    self.colour = Colour(1,0.0,0.0,1)
end

function Class:Render(camera)
    if self.material then
		    self.material:Use()
		  else
		      Material:Reset()
		  end
    
    love.graphics.setColor(self.colour:Unpack())
    love.graphics.draw(quad.source, self.transform.position.x - self.offset.x, self.transform.position.y - self.offset.y, 0, self.width, self.height)
end