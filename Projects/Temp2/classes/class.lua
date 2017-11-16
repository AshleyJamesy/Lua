module("class", package.seeall)

Classes 	= {}

local Class   				= {}
Class.__index 				= Class
Class.__type  				= { "Class" }
Class.__loaded 				= true

local function inherit(n, b)
 for k, v in pairs(b) do
		if n[k] then
		else
			if type(b[k]) == "function" then
				n[k] = v
			end
		end

		--print("	", k, v)
	end
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
	
	if instance.__Setup then
		instance:__Setup()
	end

	return instance:New(...) or instance
end

function Class:New(...)
	
end

function Class.Quick(name, t)
	return setmetatable(t , Classes[name] or Class)
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
	
	--VARIABLE CHANGES
	--[[
	n.__newindex = function(t, k, v)
		if n.__watch ~= nil and n.__watch == true then
			local value = t.variables[k]

			if value then
				if value ~= v then
					t.variables[k] = v

					if n.ChangedValue then
						n.ChangedValue(t, k, value, v)
					end
				end
			else
				t.variables[k] = v

				if n.NewValue then
					n.NewValue(t, k, v)
				end
			end

			rawset(t.variables,k,n)
		else
			rawset(t,k,n)
		end
	end

	n.__index = function (t, k)
		if n.__watch ~= nil and n.__watch == true then
			return t.variables[k] or n[k]
		else
			return rawget(t,k) or n[k]
		end
	end
	]]

	n.__index = function (t, k)
		return rawget(t,k) or n[k]
	end

	n.__type 		= table.Clone(b.__type)

	n.__base 		= b
	n.__loaded 		= false
	
	--n.__tostring 	= function(a)
	--	if a.ToString then
	--		return a:ToString()
	--	end

	--	return a.__type[#a.__type]
	--end

	if base and b == Class and base ~= "Class" then
		table.insert(n.__type, base)
	end

	table.insert(n.__type, name)

	--if b then
	--	inherit(n, b)
	--end

	setmetatable(n, Class)

	Classes[name] = n
	
	_G[name] = n

	return n 
end

function LoadClass(n)
	if n.__loaded then
	else
		if #n.__type > 2 then
			local ThisClass = n.__type[#n.__type]
			local BaseClass = n.__type[#n.__type - 1]

			local b = Classes[BaseClass]
			
			if b.__loaded then
			else
				LoadClass(b)
			end

			n.__type = table.Copy(b.__type)
			
			table.insert(n.__type, ThisClass)
			
			inherit(n, b)
			
			n.__base = b
			
			n.__loaded = true
		end
	end
end

--TODO:
--[[
	Fix Class Loading
	Bug: 
]]

function Load()
 --[[
	for k, n in pairs(Classes) do
		if #n.__type > 2 then
			local ThisClass = n.__type[#n.__type]
			local BaseClass = n.__type[#n.__type - 1]
			
			local b = Classes[BaseClass]

			n.__type = table.Copy(b.__type)

			table.insert(n.__type, ThisClass)
			
			inherit(n, b)
			
			n.__base = b
		end
	end
	]]
	
	for k, v in pairs(Classes) do
	    LoadClass(v)
	end
end

function GetClass(name)
	return Classes[name]
end