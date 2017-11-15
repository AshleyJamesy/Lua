local Class = class.NewClass("Polygon", "Shape")

local function magnitude(x,y)
	return math.abs(math.sqrt(x * x + y * y))
end

local function normalised(x,y)
	local m = magnitude(x,y)
	return math.abs(x) > 0 and x / m or 0, math.abs(y) > 0 and y / m or 0
end

local function perpendicular(x,y)
	return -y, x
end

local function cross(x1,y1,x2,y2)
	return x1 * y2 - y2 * x2
end

local function dot(x1,y1,x2,y2)
	return x1 * x2 + y1 * y2
end

function Class:New(points)
	Shape.New(self, "Polygon")
	
	self.scale 	= 1.0
	self.shapes = {}
end