local Class = class.NewClass("Point", "Shape")

function Class:New()
	Shape.New(self, "Point")
end