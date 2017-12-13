local Class = class.NewClass("AABB", "Shape")

function Class:New(extents)
	Shape.New(self, "AABB")
	
	self.extents = extents or Vector2(0.5, 0.5)
end