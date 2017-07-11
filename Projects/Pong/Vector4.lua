include("class")

local Class, BaseClass = class.NewClass("Vector4")
Vector4 = Class

function Class:New(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function Class:__add(other)
    return Vector4(self.x + other.x, self.y + other.y)
end

function Class:__sub(other)
    return Vector4(self.x - other.x, self.y - other.y)
end

function Class:__mul(scale)
    return Vector4(self.x * scale, self.y * scale)
end

function Class:__tostring()
    return self.x .. ", " .. self.y .. ", " .. self.z .. ", " .. self.w
end

function Class:Magnitude()
    return math.abs(math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w))
end

function Class:GetTable()
    return { self.x, self.y, self.z, self.w }
end

function Class:Normalised()
    local magnitude = self:Magnitude()
    local vector = Vector4()
    
    vector.x = (math.abs(self.x) > 0) and (self.x / magnitude) or 0
    vector.y = (math.abs(self.y) > 0) and (self.y / magnitude) or 0
    vector.z = (math.abs(self.z) > 0) and (self.z / magnitude) or 0
    vector.w = (math.abs(self.w) > 0) and (self.w / magnitude) or 0
    
    return vector
end