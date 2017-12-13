include("class")

local Class, BaseClass = class.NewClass("Vector2")
Vector2 = Class

function Class:New(x, y)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x or 0
		self.y = x.y or 0
		return
	end
	
	self.x = x or 0
	self.y = y or 0
end

function Class.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function Class.__add(a,b)
	--Vector*>2 + Vector*>2
	local x = (a.x or 0) + (b.x or 0)
	local y = (a.y or 0) + (b.y or 0)
	return Vector2(x,y)
end

function Class.__sub(a,b)
	--Vector*>2 - Vector*>2
	local x = (a.x or 0) - (b.x or 0)
	local y = (a.y or 0) - (b.y or 0)
	return Vector2(x,y)
end

function Class.__mul(a,b)
	if TypeOf(a) == "number" then
		--float * Vector2
		return Vector2(b.x * a, b.y * a)
	end
	if TypeOf(b) == "number" then
		--Vector2 * float
		return Vector2(a.x * b, a.y * b)
	end

	--Vector2 * Vector2
	return Vector2(a.x * b.x, a.y * b.y)
end

function Class:__unm()
	return Vector2(-self.x, -self.y)
end

function Class:ToString()
	return self.x .. ", " .. self.y
end

function Class:Set(x, y)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x
		self.y = x.y
		return
	end

	self.x = x or 0
	self.y = y or 0
end

function Class:Magnitude()
	return math.abs(math.sqrt(self.x * self.x + self.y * self.y))
end

function Class:Sum()
	return self.x + self.y
end

function Class.Lerp(a, b, t)
	return a + (b - a) * t
end

function Class.Rotation(r)
	return Vector2(-math.sin(r), math.cos(r))
end

function Class:ToAngle()
	local angle = math.atan2(self.y, self.x)
	
	if angle < 0 then
		return math.abs(math.rad(-360) - angle)
	end
	
	return math.abs(angle)
end

function Class:Normalised()
	local _magnitude = self:Magnitude()
	local x = math.abs(self.x) > 0 and self.x / _magnitude or 0
	local y = math.abs(self.y) > 0 and self.y / _magnitude or 0

	return Vector2(x, y)
end

function Class.Dot(a,b)
	return a.x * b.x + a.y * b.y
end

function Class:GetTable()
	return { self.x, self.y }
end

function Class:Unpack()
	print(self.x, self.y)
	return self.x, self.y
end