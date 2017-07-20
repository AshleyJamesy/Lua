include("class")
include("Layer")

local Class, BaseClass = class.NewClass("Scene")
Scene = Class

function Class:New(name)
	self.name			     = name
	self.objects    = {}
	self.components = {}
	self.layers     = {}
	
	for i = 0, 7 do
	    self.layers[i] = Layer("Layer_" .. i, i)
	end
	self.layers[0].name = "Default"
end

function Class:AddLayer(index, name)
    self.layers[index].name = name
end

function Class:AddGameObject(gameObject)
    if gameObject then
        local layer = self.layers[gameObject.layer]
        table.insert(layer.objects, gameObject)
    end
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