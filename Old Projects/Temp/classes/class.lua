module("class", package.seeall)

Classes = {}

local Class   				= {}
Class.__index 				= Class
Class.__type  				= { "Class" }

Class.__tostring 			= function(t)
	if t.ToString then
		return t:ToString()
	end

	return self.__type[#self.__type]
end

local function Inherit(n, b)
	for k, v in pairs(b) do
		if n[k] then
		else
			if type(b[k]) == "function" then
				n[k] = v
			end
		end
	end
end

function Class:__call(...)
	local instance = setmetatable({ variables = {} }, self)
	
	return instance:New(...) or instance
end

function Class:New(...)
	
end

function Class:Base()
	return self.__base
end

function Class:Type()
	return TypeOf(self)
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
	return self.__type[#self.__type]
end

function Class:Types()
	return self.__type
end

function New(name, ...)
	return Classes[name](...)
end

function NewClass(name, base)
	if Classes[name] then
		return Classes[name], Classes[name]:Base()
	end
	
	local b = Classes[name] or Class
	local n = {}
	
	n.__newindex = function(t, key, new)
		local value = t.variables[key]

		if value then
			if value ~= new then
				t.variables[key] = new

				if t.ChangedValue then
					t.ChangedValue(t, key, value, new)
				end
			end
		else
			t.variables[key] = new

			if t.NewValue then
				t.NewValue(t, key, new)
			end
		end
	end

	n.__index = function (t, key)
		return t.variables[key] or n[key]
	end

	n.__tostring 	= Class.__tostring

	n.__type 		= table.Copy(b.__type)
	n.__base 		= b
	
	if base and b == Class and base ~= "Class" then
		table.insert(n.__type, base)
	end

	table.insert(n.__type, name)

	if b then
		Inherit(n, b)
	end

	setmetatable(n, Class)

	Classes[name] = n
	
	_G[name] = n

	return n 
end

function Load()
	for k, n in pairs(Classes) do
		if #n.__type > 2 then
			local ThisClass = n.__type[#n.__type]
			local BaseClass = n.__type[#n.__type - 1]
			
			local b = Classes[BaseClass]
			
			n.__type = table.Copy(b.__type)
			
			table.insert(n.__type, ThisClass)
			
			Inherit(n, b)
			
			n.__base = b
		end
	end
end

function GetClass(name)
	return Classes[name]
end