local Class = class.NewClass("Vector4")

function Class:New(x, y, z, w)
    if x and TypeOf(x) ~= "number" then
        self.x = x.x or 0
        self.y = x.y or 0
        self.z = x.z or 0
        self.w = x.w or 0
    return
    end

    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function Class.__add(a,b)
    --Vector*>4 + Vector*>4
    local x = (a.x or 0) + (b.x or 0)
    local y = (a.y or 0) + (b.y or 0)
    local z = (a.z or 0) + (b.z or 0)
    local w = (a.w or 0) + (b.w or 0)
    return Vector4(x,y,z,w)
end

function Class.__sub(a,b)
    --Vector*>4 - Vector*>4
    local x = (a.x or 0) - (b.x or 0)
    local y = (a.y or 0) - (b.y or 0)
    local z = (a.z or 0) - (b.z or 0)
    local w = (a.w or 0) - (b.w or 0)
    return Vector4(x,y,z,w)
end

function Class.__mul(a,b)
    --float * Vector4
    if TypeOf(a) == "number" then
        return Vector4(b.x * a, b.y * a, b.z * a, b.w * a)
    end

    --Vector4 * float
    if TypeOf(b) == "number" then
        return Vector4(a.x * b, a.y * b, a.z * b, a.w * b)
    end

    return Vector4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
end

function Class:ToString()
    return self.x .. ", " .. self.y .. ", " .. self.z .. ", " .. self.w
end

function Class:Magnitude()
    return math.abs(math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w))
end

function Class:Sum()
    return self.x + self.y + self.z + self.w
end

function Class.Lerp(a, b, t)
    return a + (b - a) * t
end

function Class:Normalised()
    local magnitude = self:Magnitude()
    local x = math.abs(self.x) > 0 and self.x / _magnitude or 0
    local y = math.abs(self.y) > 0 and self.y / _magnitude or 0
    local z = math.abs(self.z) > 0 and self.z / _magnitude or 0
    local w = math.abs(self.w) > 0 and self.w / _magnitude or 0
    
    return Vector4(x,y,z,w)
end

function Class:GetTable()
    return { self.x, self.y, self.z, self.w }
end

function Class:Unpack()
    return self.x, self.y, self.z, self.w
end