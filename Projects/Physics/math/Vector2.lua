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

function Class:__tostring()
    return self.x .. ", " .. self.y
end

function Class:ToString()
    return self:__tostring()
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

function Class:Normalised()
    local _magnitude = self:Magnitude()
	local x = math.abs(self.x) > 0 and self.x / _magnitude or 0
	local y = math.abs(self.y) > 0 and self.y / _magnitude or 0

    return Vector2(x, y)
end

function Class:GetTable()
    return { self.x, self.y }
end