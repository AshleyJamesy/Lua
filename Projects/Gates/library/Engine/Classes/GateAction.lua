local Class = class.NewClass("GateAction")
Class.Groups = {}

function Class:New(group, name)
    if Class.Groups[group] then
        if Class.Groups[group][name] then
            return Class.Groups[group][name]
        end
    end
    
    self.name         = name
    self.input        = {}
    self.input_types  = {}
    self.output       = {}
    self.output_types = {}
    
    if Class.Groups[group] == nil then
        Class.Groups[group] = {}
    end
    
    Class.Groups[group][name] = self
end

function Class.Output(gate, ...)
    
end

function Class.Reset(gate)
    
end

function Class.Label(gate)
    
end