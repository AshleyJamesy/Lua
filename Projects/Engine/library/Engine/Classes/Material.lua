local Class = class.NewClass("Material")
Class.Materials = {}

function Class:New(name, path, ...)
	if Class.Materials[name] then 
		return Class.Materials[name] 
	end

	self.name 		= name
	self.shader 	= Shader(path, ...)
	self.variables 	= {}

	Class.Materials[name] = self
end

function Class:Use()
	self.shader:Use()
	
	for k, v in pairs(self.variables) do
		if type(v) == "table" then
			if v.class == "Colour" then
				self.shader:SendColour(k, v.data)
			else
				self.shader:Send(k, v.data)
			end
		else
			self.shader:Send(k, v.data)
		end
	end
end

function Class:Update()
	for k, v in pairs(self.variables) do
		if type(v) == "table" then
			if v.class == "Colour" then
				self.shader:SendColour(k, v.data)
			else
				self.shader:Send(k, v.data)
			end
		else
			self.shader:Send(k, v.data)
		end
	end
end

function Class:Set(name, class, ...)
	if self.variables[name] == nil then
		self.variables[name] = {}
	end
	
	self.variables[name].class 	= class
	self.variables[name].data 	= ...
	
	--if class == "Colour" then
	--	self.shader:SendColour(name, ...)
	--else
	--	self.shader:Send(name, ...)
	--end
end

function Class:Get(name)
	return self.variables[name].data
end