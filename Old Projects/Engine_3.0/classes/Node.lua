local Class = class.NewClass("Node", "Object")

function Class:New()
	Class.Base.New(self)
	
	self.origin 		= Vector2(0.5, 0.5)
	self.size 			= Vector2(20, 20)
	self.connections 	= {}
end

function Class:Update()
end

function Class:Render()
	love.graphics.rectangle("line", -self.size.x * self.origin.x, -self.size.y * self.origin.y, self.size.x, self.size.y)
end