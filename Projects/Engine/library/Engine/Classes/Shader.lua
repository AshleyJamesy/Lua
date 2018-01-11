local Class = class.NewClass("Shader")
Class.Shaders = {}

function Class:New(path, code)
	if Class.Shaders[path] then 
		return Class.Shaders[path] 
	end
	
	local status, shader
	if code then
		status, shader = pcall(love.graphics.newShader, code)
		self.code = code
	else
		status, shader = pcall(love.graphics.newShader, GetProjectDirectory() .. path)
		self.code = love.filesystem.read(GetProjectDirectory() .. path)
	end

	if status then
	else
		error(path .. " " .. shader)
	end
	
	self.source 	= shader
	self.properties = {}
	
	Class.Shaders[path] = self
end

function Class:Send(name, ...)
	local status, err = pcall(self.source.send, self.source, name, ...)
end

function Class:SendColour(name, ...)
	local status, err = pcall(self.source.sendColor, self.source, name, ...)
end

function Class:Use(shader)
	love.graphics.setShader(self.source)
end