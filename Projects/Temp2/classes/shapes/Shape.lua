local Class = class.NewClass("Shape")
Class.Types = { "None", "Point", "Circle", "AABB", "Line", "Ray", "Polygon" }

function Class:New(type)
	self.type 	= type or "None"
end