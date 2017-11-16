local Class = class.NewClass("Script", "MonoBehaviour")

function Script:New(name)
    if class.GetClass(name) then
        return class.GetClass(name)
    else
        local script = class.NewClass(name, "MonoBehaviour")
        
        script.New = function(s, gameObject, ...)
            Class:Base().New(s, gameObject, ...)
        end
        
        return script
    end
end
    