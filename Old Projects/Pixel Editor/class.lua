include("extensions/table")

module("class", package.seeall)

Classes = {}

local Class   = {}
Class.__index = Class
Class.__type  = { "Class" }
Class.__ignoreProperties = { "__ignoreProperties" }

function Class:__call(...)
	local instance = setmetatable({}, self)

	instance:New(...)
	
	return instance
end

function Class:New(...)

end

function Class:IgnoreProperty(property)
	if table.HasValue(self.__ignoreProperties, property) then
		return
	end
	
	table.insert(self.__ignoreProperties, property)
end

function Class:Serialise()
	local t        = {}
	t.type         = self:Type()
	t.properties   = {}

	for k, v in pairs(self) do
		if table.HasValue(self.__ignoreProperties, k) then
		else
            local type = TypeOf(v)
			if IsType(v, "Class") then
				t.properties[k] = v:Serialise()
			elseif type == "userdata" then
                t.properties[k] = "USERDATA"
            else
				t.properties[k] = v
			end
		end
	end

	return t
end

function DeSerialise(tbl)
	local instance = New(tbl.__type)
	
	for k,v in pairs(tbl.properties) do
		instance[k] = v
	end

	return instance
end

function Class:Base()
	return GetClass(self.__type[#self.__type - 1]) or Class
end

function Class:Type()
	return TypeOf(self)
end

function Class:Types()
	return self.__type
end

function Class:IsType(name)
	return IsType(self, name)
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
	n.__index			= n
	n.__call			 = Class.__call
	n.__tostring		 = Class.__tostring
	n.__type			 = table.Copy(b.__type)

	table.insert(n.__type, name)
	
	setmetatable(n, b)
	
	Classes[name] = n
	
	return n, b
end

function GetClass(name)
	return Classes[name]
end