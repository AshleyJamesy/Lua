local Class = class.NewClass("Ray", "Shape")

function Class:New(direction)
	Shape.New(self, "Ray")
	
	self.direction = direction
end