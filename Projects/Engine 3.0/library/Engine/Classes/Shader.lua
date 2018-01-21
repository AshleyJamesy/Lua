local Class = class.NewClass("Shader")
Class.Shaders = {}

local glsl_Types = 
{
	"void",
	"bool",
	"int",
	"float",
	"vec2",
	"vec3",
	"vec4",
	"bvec2",
	"bvec3",
	"bvec4",
	"ivec2",
	"ivec3",
	"ivec4",
	"mat2",
	"mat3",
	"mat4",
	"mat2x2",
	"mat2x3",
	"mat2x4",
	"mat3x2",
	"mat3x3",
	"mat3x4",
	"mat4x2",
	"mat4x3",
	"mat4x4",
	"sampler1D",
	"sampler2D",
	"sampler3D",
	"samplerCube",
	"sampler1DShadow",
	"sampler2DShadow"
}

local function GetKeywords(code)
	local t = {}
	local i = 1
	local j = 1

	while(true) do
		local find = string.find(code, "uniform", i)
		if find then
			local endcase = string.find(code, ";", find)

			if endcase then
				local a = string.sub(code, find, endcase)

				
				for word in string.gmatch(a, "[A-Za-z0-9_]+") do
					if word == "uniform" then
					else
						t[j] = word

						j = j + 1
					end
				end
			end
		else
			break
		end

		i = find + 1
	end

	return t
end

local function GetVariables(code)
	local keywords = GetKeywords(code)

	local i = 1
	local t = ""
	local p = {}
	for k, v in pairs(keywords) do
		if (k % 2) == 1 then
			t = v
		else
			p[v] = t
			t = ""
		end
	end

	return p
end

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
		print("Shader Compiler:\n shader:\"" .. path .. "\" " .. shader)
		
		return Shader("Default", [[
			#ifdef VERTEX
				vec4 position(mat4 _, vec4 __)
				{
					return ProjectionMatrix * TransformMatrix * VertexPosition;
				}
			#endif

			#ifdef PIXEL
				vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
				{
					return Texel(texture, uv_coords) * colour;
				}
			#endif
		]])
	end

	self.source 	= shader
	self.properties = GetVariables(self.code)
 
	Class.Shaders[path] = self
end

function Class:Send(name, ...)
	if self.properties[name] then
		local status, err = pcall(self.source.send, self.source, name, ...)
	end
end

function Class:SendColour(name, ...)
	if self.properties[name] and self.properties[name] == "vec3" or self.properties[name] == "vec4" then
		local status, err = pcall(self.source.sendColor, self.source, name, ...)
	end
end

function Class:HasUniform(name)
	return self.properties[name] ~= nil
end

function Class:GetUniforms()
    return self.properties
end

function Class:Use()
	love.graphics.setShader(self.source)
end

function Class:Reset()
	love.graphics.setShader()
end