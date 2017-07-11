include("class")

local Class, BaseClass = class.NewClass("Vector2")
Vector2 = Class

function Class:New(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Class:__add(other)
    local _new = Vector2(0,0)
    _new.x = self.x + other.x
    _new.y = self.y + other.y
    
    return _new
end

function Class:__sub(other)
    local _new = Vector2(0,0)
    _new.x = self.x - other.x
    _new.y = self.y - other.y
    
    return _new
end

function Class:__mul(scale)
    local _new = Vector2(0,0)
    _new.x = self.x * scale
    _new.y = self.y * scale
    
    return _new
end

function Class:__tostring()
    return self.x .. ", " .. self.y
end

function Class:Magnitude()
    return math.abs(math.sqrt(self.x * self.x + self.y * self.y))
end

function Class:Normalised()
    local _magnitude = self:Magnitude()
    local _new = Vector2(self.x, self.y)
    
    if(math.abs(self.x) and math.abs(self.y)) then
        _new.x = self.x / _magnitude
        _new.y = self.y / _magnitude
    else
        _new.x = 0
        _new.y = 0
    end
    
    return _new
end