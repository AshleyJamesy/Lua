local Class = class.NewClass("Vector3")

function Class:New(x, y, z)
	if x and TypeOf(x) ~= "number" then
		self:SerialiseField("x", x.x or 0)
        self:SerialiseField("y", x.y or 0)
		self:SerialiseField("z", x.z or 0)
		return
	end

    self:SerialiseField("x", x or 0)
    self:SerialiseField("y", y or 0)
    self:SerialiseField("z", z or 0)
end

function Class.__eq(a,b)
    return a.x == b.x and a.y == b.y and a.z == b.z
end

function Class.__add(a, b)
	--Vector*>3 + Vector*>3
	local x = (a.x or 0) + (b.x or 0)
    local y = (a.y or 0) + (b.y or 0)
    local z = (a.z or 0) + (b.z or 0)
    return Vector3(x,y,z)
end

function Class.__sub(a, b)
	--Vector*>3 - Vector*>3
    local x = (a.x or 0) - (b.x or 0)
    local y = (a.y or 0) - (b.y or 0)
    local z = (a.z or 0) - (b.z or 0)
    return Vector3(x,y,z)
end

function Class.__mul(a, b)
	--float * Vector3
    if TypeOf(a) == "number" then
    	return Vector3(b.x * a, b.y * a, b.z * a)
    end

    --Vector3 * float
    if TypeOf(b) == "number" then
    	return Vector3(a.x * b, a.y * b, a.z * b)
    end

    --Vector3 * Vector3
    return Vector2(a.x * b.x, a.y * b.y, a.z * b.z)
end

function Class:ToString()
    return self.x .. ", " .. self.y .. ", " .. self.z
end

function Class.Lerp(a, b, t)
    return a + (b - a) * t
end

function Class:Magnitude()
    return math.abs(math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z))
end

function Class:Sum()
	return self.x + self.y + self.z
end

function Class:Normalised()
	local _magnitude = self:Magnitude()
	local x = math.abs(self.x) > 0 and self.x / _magnitude or 0
	local y = math.abs(self.y) > 0 and self.y / _magnitude or 0
	local z = math.abs(self.z) > 0 and self.z / _magnitude or 0

    return Vector3(x, y, z)
end

function Class.Dot(a,b,c)
    return a.x * b.x * c.x + a.y * b.y * c.y + a.z * b.z * c.z
end

function Class.Cross(a,b)
    local x = a.y * b.z - a.z * b.y
    local y = a.z * b.x - a.x - b.z
    local z = a.x * b.y - a.y * b.x
    return Vector2(x,y,z)
end

function Class:GetTable()
    return { self.x, self.y, self.z }
end