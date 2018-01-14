local Class = class.NewClass("Vector2")
Class.__ctype = true

--Constructor
function Class:New(x, y)
	self.x = x or 0
	self.y = y or 0
end

--OPERATIONS
function Class.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function Class.__add(a,b)
	--Vector*2 + Vector*2
	return class.Quick("Vector2", {x = (a.x or 0) + (b.x or 0), y = (a.y or 0) + (b.y or 0)})
end

function Class.__sub(a,b)
	--Vector*2 - Vector*2
	return class.Quick("Vector2", {x = (a.x or 0) - (b.x or 0), y = (a.y or 0) - (b.y or 0)})
end

function Class.__mul(a,b)
	if type(a) == "number" then
		--float * Vector2
		return class.Quick("Vector2", {x = b.x * a, y = b.y * a})
	end
	if type(b) == "number" then
		--Vector2 * float
		return class.Quick("Vector2", {x = a.x * b, y = a.y * b})
	end

	--Vector2 * Vector2
	return class.Quick("Vector2", {x = a.x * b.x, y = a.y * b.y})
end

function Class:__unm()
	return class.Quick("Vector2", {x = -self.x, y = -self.y})
end

function Class:__tostring()
	return self.x .. ", " .. self.y
end

--GENERAL FUNCTIONS
function Class:Set(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Class:Sum()
	return self.x + self.y
end

function Class:Magnitude()
	return math.abs(math.sqrt(self.x * self.x + self.y * self.y))
end

function Class:Normalised()
	local _magnitude = self:Magnitude()

	return class.Quick("Vector2", {
		x = math.abs(self.x) > 0 and self.x / _magnitude or 0, 
		y = math.abs(self.y) > 0 and self.y / _magnitude or 0
	})
end

function Class:Normalise()
	local _magnitude = self:Magnitude()
	self.x = math.abs(self.x) > 0 and self.x / _magnitude or 0
	self.y = math.abs(self.y) > 0 and self.y / _magnitude or 0
end

function Class.Dot(a,b)
	return a.x * b.x + a.y * b.y
end

function Class:Perpendicular()
	return class.Quick("Vector2", {x = -self.y, y = self.x})
end 

function Class.InRange(a, b, c)
	return a.x > b.x and a.x < c.x and a.y > b.y and a.y < c.y
end

function Class.Lerp(a, b, t)
	return a + (b - a) * t
end

function Class.Rotation(r)
	return class.Quick("Vector2", {x = math.sin(r), y = -math.cos(r)})
end

function Class:ToAngle()
	local angle = math.atan2(self.y, self.x)
	
	if angle < 0 then
		return math.abs(-3.1415 - angle)
	end
	
	return math.abs(angle) - 3.1415
end

function Class:Unpack()
	return self.x, self.y
end

