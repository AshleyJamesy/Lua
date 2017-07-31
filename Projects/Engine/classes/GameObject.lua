local Class = class.NewClass("GameObject", "Object")
Class.limit = 0

function Class:New(active)
	Class.Base.New(self)
	
	self.active 	= active or true
	self.gameObject = self
	self.tag 		= ""
	self.layer 		= 0
	
	self.transform 	= Transform(self)
	self.components = { self.transform }

	hook.Call("GameObjectInitalised", self)
end

function Class.Instantiate(prefab)
	local gameObject = GameObject()
	gameObject:DeSerialise(prefab)

	return gameObject
end

function Class:Prefab(name)
	local prefab = Prefab(name or self.name)
	prefab.components = self:Serialise()
	
	return prefab
end

function Class:Serialise()
	local t = {}

	for k, component in pairs(self.components) do
		t[k] = component:Serialise()
	end
	
	return t
end

function Class:DeSerialise(prefab)
	self.components = {}
	for k, component in pairs(prefab.components) do
		self.components[k] = class.DeSerialise(component)
	end

	for k, component in pairs(prefab.components) do
		self.components[k].gameObject 	= self
		self.components[k].transform 	= self.components[1]

		hook.Call("ComponentInitalised", self.components[k])
		
		if IsType(self.components[k], "MonoBehaviour") then
			self.components[k]:Awake()
			self.components[k]:Start()
		end
	end
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
		
		if self.active then
			instance:Awake(...)
			instance:Start(...)
		end
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