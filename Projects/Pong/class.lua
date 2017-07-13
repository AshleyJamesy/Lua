include("table_extended")

module("class", package.seeall)

local Classes = {}

local metaIndex = function(self, key)
    if self == self.__base then
        return nil
    end
    
    return self.__base[key]
end

local metaCall = function(self, ...)
    local t = {}
    
    t.__base = self
    
    setmetatable(t, self)
    
    self.New(t, ...)
    
    return t
end

local metaTypes = function(self)
    if self.__type then
        return self.__type
    end
    
    return {}
end

local metaType = function(self)
    return Classes[self.__type[#self.__type]]
end

local Base = {
    __call = metaCall,
    __type = { "table", "class" }
}

NewClass = function(newclass, derived)
    if Classes[newclass] then    
        return
    end
    
    local d = Classes[derived] or Base
    
    local t = {}
    t.__index   = metaIndex
    t.__call    = metaCall
    t.__base    = Classes[derived]

    t.__type = table.Copy(d.__type or {}, {})
    table.insert(t.__type, newclass)
    
    t.Types     = metaTypes
    t.Type      = metaType
    
    Classes[newclass] = t
    
    return setmetatable(t, d), Classes[derived]
end

function Get(name)
	return Classes[name]
end

function New(name)
	return Classes[name]()
end