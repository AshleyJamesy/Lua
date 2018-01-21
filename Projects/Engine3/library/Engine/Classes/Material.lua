local Class = class.NewClass("Material")
Class.Materials = {}
Class.Material = nil

function Class:New(name, shader)
    if Class.Materials[name] then
        return Class.Materials[name]
    end
    
    self.shader = Shader(shader)
    
    self.properties = {
        
    }
    
    Class.Materials[name] = self
end

function Class:Use()
    if Class.Material == self then
        return
    end
    
    self.shader:Use()
    
    for k, v in pairs(self.shader:GetUniforms()) do
        if self.properties[k] then
            self.shader:Send(k, self.properties[k])
        end
    end
    
    Class.Material = self   
end

function Class:Set(name, ...)
    self.properties[name] = ...
end