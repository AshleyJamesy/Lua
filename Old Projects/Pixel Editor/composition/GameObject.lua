include("class")
include("composition/Object")
include("composition/components/Transform")
include("composition/scene/SceneManager")

local Class, BaseClass = class.NewClass("GameObject", "Object")
GameObject = Class

function Class:New(name)
	BaseClass.New(self)

	self.tag 	= ""
	self.layer 	= 0
	
	--TODO Scene
	self.scene 		= SceneManager.GetActiveScene()
	--TODO Transform
	self.transform 		= Transform(self)
	self.components 	= { self.transform }
end

function Class:Serialise()
	local t = {}
	t.components = {}

	for k, v in pairs(self.components) do
		t.components[k] = v:Serialise(true)
	end
	
	return t
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

function Class:AddComponent(type)
	local component = class.GetClass(type)
	if component then
		if component:IsType("MonoBehaviour") then
			local instance = class.New(type, self)
			table.insert(self.components, instance)
			
			instance:Awake();
			instance:Start();

			self:SendMessage("ComponentAdded", instance)
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