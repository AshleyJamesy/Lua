include("extensions/table")

module("class", package.seeall)

local Classes = {}

local Class   = {}
Class.__index = Class
Class.__type  = {}

function Class:__call(...)
    local instance = setmetatable({}, self)
    instance:New(...)
    
    return instance
end

function Class:New(...)

end

function Class:Type()
    return self.__type[#self.__type]
end

function Class:Types()
    return self.__type
end

function NewClass(name, derived)
    local d   = Classes[derived] or Class
    local n   = {}
    n.__index = n
    n.__call  = Class.__call
    n.__type  = {}
    
    table.copy(d.__type, n.__type, true)
    table.insert(n.__type, name)
    
    setmetatable(n, d)
    
    Classes[name] = n
    
    return n, d
end