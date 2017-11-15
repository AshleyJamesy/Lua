local Class = class.NewClass("GameObject")

function Class:New()
	self.position 	= Vector2(0,0)
	self.rotation 	= 0
	self.components = {}
end

function Class:AddComponent(type, ...)
	local component = class.GetClass(type)
	if component then
		if component:IsType("MonoBehaviour") then
			local instance = class.New(type, self, ...)
			table.insert(self.components, instance)
			
			instance:Awake();
			instance:Start();
		end
	end
end

function Class:RemoveComponent(type)
	
end

function Class:GetComponent(type)
	for k, v in pairs(self.components) do
		if type == v:Type() then
			return v
		end
	end
	
	return nil
end

function Class:GetComponents(type)
	local components = {}
	for k, v in pairs(self.components) do
		if type == v:Type() then
			table.insert(components, v)
		end
	end
	
	return components
end

function Class:RemoveComponents(type)
	
end