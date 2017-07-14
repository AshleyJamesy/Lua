include("class")

local Class, BaseClass = class.NewClass("Material")
Material = Class

local Materials = {}

function Class:New(name, restitution)
    name = TypeOf(name) == "string" and name or "Default"
    restitution = TypeOf(restitution) == "number" and number or 0
    
    if not Materials[name] then
        Materials[name] = self
    end
    
    Materials[name].restitution = restitution or 0
end

function Class.GetCoefficient(a,b)
    local x = TypeOf(a) == "string" and Materials[a] or a
    local y = TypeOf(b) == "string" and Materials[b] or b
    
    return math.min(a.restitution or 0, b.restitution or 0)
end

function Class.Get(name)
    return Materials[name]
end