local Class = class.NewClass("Line", "Shape")

function Class:New(x, y)
	Shape.New(self, "Line")
	
	self.x = x or Vector2(0,0)
	self.y = y or Vector2(0,0)
end