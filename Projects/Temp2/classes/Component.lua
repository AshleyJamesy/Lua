local Class 	= class.NewClass("Component", "Object")
Class.__limit 	= 0
Class.Components = {}

function Class:__Setup()
	--ID
	local typename = self:Type()
	local c = class.GetClass(typename)
	c.__count = (c.__count or 0) + 1
	
	self.id = c.__count
	
	--Batching
	if not Class.Components[typename] then
		Class.Components[typename] = {}
	end
	
	Class.Components[typename][self.id] = self
end

function Class:New(gameObject, ...)
	Class:Base().New(self)

	self.gameObject = gameObject
end

function Class:AddComponent(name, ...)
	return self.gameObject:AddComponent(name, ...)
end

function Class:RemoveComponent(name)
	self.gameObject:RemoveComponent(name)
end

function Class:RemoveComponents(name)
	self.gameObject:RemoveComponents(name)
end

function Class:GetComponent()
	return self.gameObject:GetComponent(name)
end

function Class:GetComponents()
	return self.gameObject:GetComponents(name)
end

function Class:SendMessage(method, require, ...)
	self.gameObject:SendMessage(method, require, ...)
end

--Quicker to check for this function than loop through types
function Class:IsComponent()
	return true
end