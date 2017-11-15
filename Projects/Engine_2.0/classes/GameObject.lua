local Class = class.NewClass("GameObject", "Object")

function Class.Instantiate(object)
	local object = class.DeSerialise(object, false)
	
	object.transform = object.components[1]
	
	for k, v in pairs(object.components) do
		v.gameObject 	= object
		v.transform 	= object.transform
	end
	
	for k, v in pairs(object.components) do
		if IsType(v, "MonoBehaviour") then
			v:Awake()
			v:Start()
		end
	end
	
	return object
end

function Class:New(transform)
	Class.Base.New(self)
	
	if transform == nil then
		self.transform = Transform(self)

		self:SerialiseField("components", { self.transform })
	else
		self:SerialiseField("components", {})
	end
	
	self.gameObject = self
end

function Class:Initalise()
	for k, v in pairs(self.components) do
		hook.Call("ComponentAdded", v)
	end
end

function Class:BroadcastMessage(method, ...)
	for _, component in pairs(self.components) do
		if component[method] then
			component[method](component, ...)
		end
	end

	--[[
	for _, child in pairs(self.transform.children) do
		child.gameObject:BroadcastMessage(method, ...)
	end
	]]
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

function Class:AddComponent(name, ...)
	local component = class.GetClass(name)
	if component and component:IsType("Component") then
		local instance = class.New(name)
		instance.gameObject = self

		table.insert(self.components, instance)
		
		if instance:IsType("MonoBehaviour") then
			instance:Awake(...)
			instance:Start(...)
		end
	end
end

function Class:RemoveComponent(name)
	
end

function Class:GetComponent(name)
	for k, v in pairs(self.components) do
		if name == v:Type() then
			return v
		end
	end
	
	return nil
end

function Class:GetComponents(name)
	local components = {}
	for k, v in pairs(self.components) do
		if name == v:Type() then
			table.insert(components, v)
		end
	end
	
	return components
end