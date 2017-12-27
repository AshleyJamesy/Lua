local Class = class.NewClass("Shader")
Class.Shaders = {}

function Class:New(path)
	if Class.Shaders[path] then 
		return Class.Shaders[path] 
	end
	
	local status, shader = pcall(love.graphics.newShader, GetProjectDirectory() .. path)	
	
	if status then
	else
	    shader = Shader("resources/shaders/default.glsl").source
	end
	
	self.source     = shader
	self.variables  = {}

	Class.Shaders[path] = self
end

function Class:Send(name, ...)
    pcall(self.source.send, self.source, name, ...)
end

function Class:SendColour(name, ...)
	   pcall(self.source.sendColor, self.source, name, ...)
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