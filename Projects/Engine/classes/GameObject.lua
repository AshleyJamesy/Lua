local Class = class.NewClass("GameObject", "Object")
Class.limit = 0

function Class:New()
	Class.Base.New(self)
	
	self.gameObject = self
	self.tag 		= ""
	self.layer 		= 0
	
	self.transform 	= Transform(self)
	self.components = { self.transform }

	hook.Call("GameObjectInitalised", self)
end

function Class:BroadcastMessage(method, ...)
	for _, component in pairs(self.components) do
		if component[method] then
			component[method](component, ...)
		end
	end

	for _, child in pairs(self.transform.children) do
		child.gameObject:BroadcastMessage(method, ...)
	end
end

function Class:SendMessage(method, ...)
	for _, component in pairs(self.components) do
		if component[method] then
			component[method](component, ...)
		end
	end
end

function Class:SendMessageUpwards(method, ...)
	
end

function Class:AddComponent(type_name, ...)
	local component = class.GetClass(type_name)
	if component and component:IsType("Component") then
		local instance = class.New(type_name, self, ...)
		
		table.insert(self.components, instance)
		
		instance:Awake(...);
		instance:Start(...);
	end
end

function Class:RemoveComponent(type_name)
	
end

function Class:GetComponent(type_name)
	for k, v in pairs(self.components) do
		if type_name == v:Type() then
			return v
		end
	end
	
	return nil
end

function Class:GetComponents(type_name)
	local components = {}
	for k, v in pairs(self.components) do
		if type_name == v:Type() then
			table.insert(components, v)
		end
	end
	
	return components
end