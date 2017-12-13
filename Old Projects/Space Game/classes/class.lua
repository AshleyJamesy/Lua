module("class", package.seeall)

Classes = {}

local Class = {}
Class.type 	= { "Class" }

function Class:__newindex(key, new)
	if not rawget(self, "variables") then
		rawset(self, "variables", {})
	end

	local value = self.variables[key]
	if value then
		if value ~= new then
			self.variables[key] = new

			if self.ChangedValue then
				self.ChangedValue(self.variables, key, value, new)
			end
		end
	else
		self.variables[key] = new

		if self.NewValue then
			self.NewValue(self.variables, key, new)
		end
	end
end

function Class:__index(key)
	if self.variables[key] == nil then
		if self.base then
			return self.base.variables[key]
		end

		return nil
	end

	return self.variables[key]
end

function Class:__call(...)
	local instance = setmetatable({ variables = {} }, self)
	
	return instance:New(...) or instance
end

function Class:New(...)

end

function Class:Types()
	return rawget(self, "type")
end

function Class:Base()
	return rawget(self, "base")
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

	n.__index 		= Class.__index
	n.__newindex 	= Class.__newindex
	n.__call		= Class.__call

	n.type		= table.Copy(b:Types())
	n.base 		= b
	
	if base and b == Class and base ~= "Class" then
		table.insert(n.type, base)
	end
	
	table.insert(n.type, name)
	
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