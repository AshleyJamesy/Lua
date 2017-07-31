local Class = class.NewClass("Prefab", "Asset")
Class.extension = "prefab"

function Class:Load(asset)
	if asset then
		--if asset exists we load the values
		self.components = asset.components
	else
		--default values if asset doesn't exist (we create one)
		self.components = {}
	end
end

function Class:DeSerialise(value)
	for k, v in pairs(value.__properties) do
		self[k] = v
	end
end