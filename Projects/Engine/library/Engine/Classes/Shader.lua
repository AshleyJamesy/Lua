local Class = class.NewClass("Shader")
Class.Shaders = {}

function Class:New(path)
	if Class.Shaders[path] then 
		return Class.Shaders[path] 
	end
	
	self.source 	= love.graphics.newShader(GetProjectDirectory() .. path)
	self.variables 	= {}

	Class.Shaders[path] = self
end

function Class:Send(name, ...)
	self.source:send(name, ...)
end

function Class:SendColour(name, ...)
	self.source:sendColor(name, ...)
end

--[[
	for runtime shader editing
]]
function Class:Update()
	for k, v in pairs(self.variables) do
		self.source:send(k, v)
	end
end

function Class:SetVariable(name, ...)
	self.variables[name] = ...
end

function Class:Use()
	love.graphics.setShader(self.source)
end

function Class:Default()
	love.graphics.setShader()
end