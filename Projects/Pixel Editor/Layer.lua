include("class")
include("composition/scene/SceneManager")

local Class, BaseClass = class.NewClass("Layer")
Layer = Class

function Class:New(name, index)
    self.index   = index
    self.name    = name
    self.canvas  = love.graphics.newCanvas()
    self.objects = {}
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

function Class:LayerToName()
    return self:ToString()
end

function Class:ToString()
    return self.name
end

function Class:Render()
    for k, v in pairs(self.objects) do
        self.canvas:renderTo(v:Render())
    end
end