module("class", package.seeall)

Classes = {}

local Class   				= {}
Class.__index 				= Class
Class.__typename 			= "Class"
Class.__type  				= { "Class" }
Class.__loaded 				= true

--Class.__readOnly 			= true

local function inherit(n, b)
	for k, v in pairs(b) do
		if rawget(n, k) then
		else
			if type(v) == "function" then
				rawset(n, k, v)
			end
		end
	end

	n.__base = b
end

function Class:__call(...)
	--VARIABLE CHANGES
	--local instance = nil
	--if self.__watch ~= nil and self.__watch == true then
	--	instance = setmetatable({ variables = {} }, self)
	--else
	--	instance = setmetatable({}, self)
	--end
	
	local instance = setmetatable({}, self)

	return instance:New(...) or instance
end

function Class:New(...)
	
end

function Quick(name, t)
	return setmetatable(t or {}, Classes[name] or Class)
end

function Class:Base()
	return self.__base
end

function Class:Type()
	return self.__typename
end

function Class:IsType(name)
	return self.__typename == name or IsType(self, name)
end

function Class:ToString()
	return self.__typename
end

function Class:Types()
	return self.__type
end

function New(name, ...)
	return Classes[name](...)
end

function NewClass(name, base, ...)
	if Classes[name] then
		return Classes[name]
	end
	
	local n = {}
 
	n.__index = function (t, k)
		return rawget(t, k) or n[k]
	end
	
	n.__call = function(t, ...)
		return setmetatable(n.__copy(t), n)
	end
	
	n.__typename = name
 
	n.__class = n
	n.__base = Class
	
	n.__loaded = false
 
	if base ~= "Class" then
	    table.insert(n.__type, base)
	end
 
	table.insert(n.__type, name)
 
	--if b then
	--	inherit(n, b)
	--end
 
	setmetatable(n, Class)
 
	Classes[name] = n
 
	return n 
end

function LoadClass(n)
	if n.__loaded then
	else
		if #n.__type > 2 then
			local ThisClass = n.__type[#n.__type]
			local BaseClass = n.__type[#n.__type - 1]
			
			local b = Classes[BaseClass]
			
			if b then
				if b.__loaded then
				else
					LoadClass(b)
				end
			else
				error("missing class <" .. BaseClass .. "> in class <" .. ThisClass .. ">")
			end
		 
			n.__type = table.Copy(b.__type)
			
			table.insert(n.__type, ThisClass)
			
			inherit(n, b)
		end
	end
	
	n.__loaded = true
end

function Load()
	for k, v in pairs(Classes) do
	    LoadClass(v)
	end
 
	hook.Call("InitaliseClass")
end

function PrintClasses()
	for k, v in pairs(Classes) do
		print(k, v)
	end
end

function GetClass(name)
	return Classes[name]
end

function GetClasses()
	return Classes
end