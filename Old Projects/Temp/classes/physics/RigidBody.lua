local Class = class.NewClass("RigidBody")

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

local function project(axis_x, axis_y, points, x, y, s, r)
	local min = dot(axis_x, axis_y, (s or 1.0) * points[1] + (x or 0), (s or 1.0) * points[2] + (y or 0))
	local max = min

	for i = 2, #points * 0.5 do
		local index = (2 * i) - (2 - 1)

		local projection = dot(axis_x, axis_y, (s or 1.0) * points[index + 0] + (x or 0), (s or 1.0) * points[index + 1] + (y or 0))

		min = projection < min and projection or min
		max = projection > max and projection or max
	end

	return min, max
end

function Class:New(points)
	self.shape 		= {
	}
	
	self.position 	= {
		x = 0, y = 0
	}
	
	self.velocity 	= {
		x = 0, y = 0
	}
	
	self.acceleration 		= 0
	self.rotation 			= 0
	self.angularVelocity 	= 0
	self.torque 			= 0
end