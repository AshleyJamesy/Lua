include("extensions/table")

module("class", package.seeall)

Classes = {}

local Class   = {}
Class.__index = Class
Class.__type  = { "Class" }

function Class:__call(...)
    local instance = setmetatable({}, self)

    instance:New(...)
    
    return instance
end

function Class:New(...)

end

function Class:Base()
    return GetClass(self.__type[#self.__type - 1]) or Class
end

function Class:Type()
    return self.__type[#self.__type]
end

function Class:Types()
    return self.__type
end

function Class:IsType(name)
    return table.HasValue(self.__type, name)
end

function Class.Equals(a,b)
    return a == b
end

function Class.Add(a,b)
    return a + b
end

function Class.Sub(a,b)
    return a - b
end

function Class.Multiply(a,b)
    return a * b
end

function Class.Greater(a,b)
    return a > b
end

function Class.GreaterEqual(a,b)
    return a >= b
end

function Class.Less(a,b)
    return a < b
end

function Class.LessEqual(a,b)
    return a <= b
end

function Class:ToString()
    return ""
end

function Class:__tostring()
    return self:ToString()
end

function New(name, ...)
    return Classes[name](...)
end

function NewClass(name, base)
    if Classes[name] then
        return Classes[name], Classes[name]:Base()
    end

    local b = Classes[base] or Class
    local n = {}
    n.__index       = n
    n.__call        = Class.__call
    n.__tostring    = Class.__tostring
    n.__type        = table.Copy(b.__type)

    table.insert(n.__type, name)
    
    setmetatable(n, b)
    
    Classes[name] = n
    
    return n, b
end

function GetClass(name)
    return Classes[name]
end