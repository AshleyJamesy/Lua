module("class", package.seeall)

Classes = {}

local Class   				= {}
Class.__index 				= Class
Class.__type  				= { "Class" }
Class.__reference 			= true
Class.__ignoreProperties 	= { "__ignoreProperties" }

function Class:__call(...)
	local instance = setmetatable({}, self)

	local override = instance:New(...)
	
	return override and override or instance
end

function Class:New(...)

end

--when serialising
--any properties that have a class that reference == true  will be saved once to a reference table
--any properties that have a class that reference == false will have a copy of the class
function Class:SetReference(boolean)
	self.__reference = boolean
end

function Class:IgnoreProperty(property)
	if table.HasValue(self.__ignoreProperties, property) then
		return
	end
	
	table.insert(self.__ignoreProperties, property)
end

--TODO: Serialising References
function Serialise(value, ...)
	if type(value) == "table" then
		local t = {}

		if IsType(value, "Class") then
			t.__type		= value:Type()
			t.__properties 	= {}

			for k, v in pairs(value) do
				if table.HasValue(value.__ignoreProperties, k) then
				else
					local s = Serialise(v)
					if s then
						t.__properties[k] = s
					end
				end
			end
		else
			for k, v in pairs(value) do
				t[k] = Serialise(v)
			end
		end

		return t
	end

	if type(value) == "userdata" then
		return nil
	end

	return value
end

--TODO: DeSerialising References
function DeSerialise(value, ...)
	if type(value) == "table" then
		--Is a Serialised Class ELSE Is Standard Object/Array
		if value.__type and value.__properties then
			local instance = New(value.__type, ...)
			
			for k, v in pairs(value.__properties) do
				instance[k] = DeSerialise(v)
			end

			return instance
		else
			local instance = {}
			
			for k, v in pairs(value) do
				instance[k] = DeSerialise(v)
			end

			return instance
		end
	end
	
	return value
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
	
	n.__index 		= n
	n.__call		= Class.__call
	n.__tostring	= Class.__tostring
	n.__type		= table.Copy(b.__type)
	n.Base 			= b

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