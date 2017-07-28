local Class = class.NewClass("Scene")
Class.main 	= nil

function Class:New(name)
	self.name 	= name
	self.layers = {}

	for i = 0, 7 do
	    self.layers[i] = Layer(self, "Layer_" .. i, i)
	end
	self.layers[0]:SetName("Default")

	if Class.main then
	else
		Class.main = self
	end

	hook.Add("ComponentInitalised", self, Class.ComponentInitalised)
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

--called on all scenes
function Class:ComponentInitalised(component)
	--check if mainscene is scene 
	if self == Class.main then
		local layer = self:GetLayerById(component.gameObject.layer)
		layer:AddComponent(component)
	end
end