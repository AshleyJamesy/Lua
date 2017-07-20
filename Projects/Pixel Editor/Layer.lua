include("class")
include("composition/scene/SceneManager")

local Class, BaseClass = class.NewClass("Layer")
Layer = Class

function Class:New(name, index)
    self.index      = index
    self.name       = name
    self.components = {}
end

function Class.NameToLayer(name, scene)
    local active = scene or SceneManager.GetActiveScene()
    for layerid, layer in pairs(active.layers) do
        if layer.name == name then
            return layer
        end
    end
    
    return nil
end

function Class.LayerToName(layer)
    return layer:ToString()
end

function Class:AddComponent(component)
    if component then
        if component:IsType("Component") then
            local batch = component:Type()
            
            if not self.components[batch] then
                self.components[batch] = {}
            end
            
            table.insert(self.components[batch], component)
        end
    end
end

function Class:MoveComponent(component, layerid)
    if component then
        if component:IsType("Component") then
            local type  = component:Type()
            local batch = self.components[type]
            if not batch then
                return
            end

            local found, index = table.HasValue(batch, component)
            if found then
                local newlayer = SceneManager.GetActiveScene():GetLayerById(layerid)

                if newlayer then
                    table.remove(batch, index)
                    newlayer:AddComponent(component)
                end
            end
        end
    end
end

function Class:Sort(type, sort)
    if component[type] then
        table.sort(component[type], sort)
    end
end

function Class:RunFunction(method, ignore, ...)
    local ignore_t = ignore or {}
    for name, batch in pairs(self.components) do
        if table.HasValue(ignore_t, name) then
        else
            --TODO: Sort
            local class = class.GetClass(name)
            if class.sort then
                --BUG: table.sort will move indexes with same sort parameters
                --table.sort(batch, class.sort)
            end

            for _, component in pairs(batch) do
                --move to new layer but render it on this layer just this once
                if component.gameObject.layer ~= self.index then
                    self:MoveComponent(component, component.gameObject.layer)
                end
                
                if component[method] then
                    component[method](component, ...)
                else
                    --break here since this component batch does not have the method we are looking for
                    break
                end
            end
        end
    end
end

function Class:ToString()
    return self.name .. ":" .. self.index
end