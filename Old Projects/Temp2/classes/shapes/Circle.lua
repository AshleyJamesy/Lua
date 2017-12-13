local Class = class.NewClass("Circle", "Shape")

function Class:New(radius)
	Shape.New(self, "Circle")
	
	self.radius = radius
end