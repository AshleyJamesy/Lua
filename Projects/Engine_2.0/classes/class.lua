module("class", package.seeall)

Classes = {}

local Class   				= {}
Class.__index 				= Class
Class.__type  				= { "Class" }
Class.__serialisable 		= {}

function Class:__call(...)
	local instance = setmetatable({}, self)
	
	Class.New(instance)
	
	return instance:New(...) or instance
end

function Class:New(...)
	
end

function Class:SerialiseField(property, value)
	self[property] = value
	
	if table.HasValue(self.__serialisable, property) then
		return
	end
	
	table.insert(self.__serialisable, property)
end

function Serialise(object)
	if type(object) == "table" then
		local t = {}

		for k, v in pairs(object) do
			if type(v) == "table" then
				if IsType(v, "Class") then
					t[k] = v:Serialise()
				else
					t[k] = Serialise(v)
				end
			else
				t[k] = v
			end
		end

		return t
	end

	return object
end

function Class:Serialise()
	local s = {
		__metatable = self:Type(),
		__values = {}
	}
	
	for k, v in pairs(self.__serialisable) do
		if table.HasKey(self, v) then
			if type(self[v]) == "table" then
				if IsType(self[v], "Class") then
					s.__values[v] = self[v]:Serialise()
				else
					s.__values[v] = class.Serialise(self[v])
				end
			else
				s.__values[v] =  class.Serialise(self[v])
			end
		end
	end

	return s
end

function DeSerialise(t, ...)
	if type(t) == "table" then
		if t.__metatable then
			local object = New(t.__metatable, ...)
			
			for k, v in pairs(t.__values) do
				object[k] = DeSerialise(v)
			end

			return object
		else
			local object = {}

			for k, v in pairs(t) do
				object[k] = DeSerialise(v)
			end

			return object
		end
	end

	return t
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

function New(name, ...)
	return Classes[name](...)
end

function NewClass(name, base)
	if Classes[name] then
		return Classes[name], Classes[name]:Base()
	end

	local b = Classes[base] or Class
	local n = {}
	
	n.__index 				= n
	n.__call				= Class.__call
	n.__tostring			= Class.__tostring
	n.__type				= table.Copy(b.__type)
	n.__serialisable		= table.Copy(b.__serialisable)
	n.Base 					= b

	if base and b == Class and base ~= "Class" then
		table.insert(n.__type, base)
	end

	table.insert(n.__type, name)
	
	setmetatable(n, b)
	
	Classes[name] = n

	_G[name] = n
	
	return n
end

function Load()
	for k, v in pairs(Classes) do
		if #v.__type > 2 then
			local ThisClass = v.__type[#v.__type]
			local BaseClass = v.__type[#v.__type - 1]

			local b = Classes[BaseClass]

			v.__type = table.Copy(b.__type)
			
			table.insert(v.__type, ThisClass)

			setmetatable(v, b)

			v.Base = b
		end
	end
end

function GetClass(name)
	return Classes[name]
end