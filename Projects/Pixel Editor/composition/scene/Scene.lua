include("class")
include("Layer")

local Class, BaseClass = class.NewClass("Scene")
Scene = Class

function Class:New(name)
	self.name		= name
	self.objects    = {}
	self.layers     = {}
	
	for i = 0, 7 do
	    self.layers[i] = Layer("Layer_" .. i, i)
	end
	self.layers[0].name = "Default"
	
	if not SceneManager.active then
		SceneManager.active = self
	end
	
	self.transform = Transform()
end

function Class:AddLayer(index, name)
    self.layers[index].name = name
end

function Class:GetLayerById(index)
	return self.layers[index]
end

function Class:GetLayerByName(name)
	for k, v in pairs(self.layers) do
		if v.name == name then
			return v
		end
	end
	
	return nil
end

function Class:AddGameObject(gameObject)
	table.insert(self.objects, gameObject)
end

function Class:AddComponent(component)
	local layer = self:GetLayerById(component.gameObject.layer)
	layer:AddComponent(component)
end

function Class:CallFunctionOnAll(method, ignore, ...)
	for layerid, layer in pairs(self.layers) do
		layer:CallFunctionOnAll(method, ignore, ...)
	end
end

function Class:CallFunctionOnType(method, type, ...)
	for layerid, layer in pairs(self.layers) do
		layer:CallFunctionOnType(method, type, ...)
	end
end

function Class:RunFunctionOnAll(method, ignore, ...)
	for layerid, layer in pairs(self.layers) do
		layer:RunFunctionOnAll(method, ignore, ...)
	end
end

function Class:RunFunctionOnType(method, type, ...)
	for layerid, layer in pairs(self.layers) do
		layer:RunFunctionOnType(method, type, ...)
	end
end