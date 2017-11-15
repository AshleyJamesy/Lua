local Class = class.NewClass("Vector2")

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
	--Vector*>2 + Vector*>2
	--return Vector2((a.x or 0) + (b.x or 0), (a.y or 0) + (b.y or 0))
	return Class.Quick("Vector2", {x = (a.x or 0) + (b.x or 0), y = (a.y or 0) + (b.y or 0)})
end

function Class.__sub(a,b)
	--Vector*>2 - Vector*>2
	--return Vector2((a.x or 0) - (b.x or 0), (a.y or 0) - (b.y or 0))
	return Class.Quick("Vector2", {x = (a.x or 0) - (b.x or 0), y = (a.y or 0) - (b.y or 0)})
end

function Class.__mul(a,b)
	if type(a) == "number" then
		--float * Vector2
		--return Vector2(b.x * a, b.y * a)
		return Class.Quick("Vector2", {x = b.x * a, y = b.y * a})
	end
	if type(b) == "number" then
		--Vector2 * float
		--return Vector2(a.x * b, a.y * b)
		return Class.Quick("Vector2", {x = a.x * b, y = a.y * b})
	end

	--Vector2 * Vector2
	--return Vector2(a.x * b.x, a.y * b.y)
	return Class.Quick("Vector2", {x = a.x * b.x, y = a.y * b.y})
end

function Class:__unm()
	return Class.Quick("Vector2", {x = -self.x, y = -self.y})
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
	--local x = math.abs(self.x) > 0 and self.x / _magnitude or 0
	--local y = math.abs(self.y) > 0 and self.y / _magnitude or 0

	return Class.Quick("Vector2", {
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

function Class.Array(n)
	local array = {}
	for i = 1, n do
		array[i] = Class.Quick("Vector2", { x = 0, y = 0 })
	end
	
	return array
end

function Class:Perpendicular()
	--return Vector2(-self.y, self.x)
	return Class.Quick("Vector2", {x = -self.y, y = self.x})
end 

function Class.InRange(a, b, c)
	return a.x > b.x and a.x < c.x and a.y > b.y and a.y < c.y
end

function Class.Lerp(a, b, t)
	return a + (b - a) * t
end

function Class.Rotation(r)
	--return Vector2(-math.sin(r), math.cos(r))
	return Class.Quick("Vector2", {x = -math.sin(r), y = math.cos(r)})
end

function Class:ToAngle()
	local angle = math.atan2(self.y, self.x)
	
	if angle < 0 then
		return math.abs(-6.28319 - angle)
	end
	
	return math.abs(angle)
end

function Class:Unpack()
	return self.x, self.y
end