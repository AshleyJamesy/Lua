local Class = class.NewClass("State")
Class.States = {}

function Class:New(name, file)
    if Class.States[name] then
        return Class.States[name]
    end
    
    if file then
        Class.States[name] = include("source/states/" .. file))
        
        print(Class.States[name])
        
        if Class.States[name] ~= nil then
            return Class.States[name]
        end
    end
    
    Class.States[name] = self
end

function Class:Update()
    
end

function Class:Render()
    
end