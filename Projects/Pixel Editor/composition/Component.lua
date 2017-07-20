include("class")
include("composition/Object")
include("composition/scene/SceneManager")

local Class, BaseClass = class.NewClass("Component", "Object")
Component = Class

function Class:New(gameObject)
	BaseClass.New(self)

	--TODO: Limits
	self.multiple = 0

	self.gameObject = gameObject
	self.tag 		= ""

	if gameObject then
		self.transform	= gameObject.transform
	else
		self.transform 	= nil
	end
	
	--Whether to add component to batching for layers
	if self.sceneAdd or self.sceneAdd == nil then
		SceneManager.GetActiveScene():AddComponent(self)
	end
end

function Class:BroadcastMessage(method, ...)
	self.gameObject:BroadcastMessage(method, ...)
end

function Class:SendMessage(method, ...)
	self.gameObject:SendMessage(method, ...)
end

function Class:SendMessageUpwards(method, ...)
	
end

function Class:GetComponent(type)
	if self.gameObject then

	end

	return nil
end

function Class:GetComponentInChildren(type)
	if self.gameObject then

	end

	return nil
end

function Class:GetComponentInParent(type)
	if self.gameObject then
		
	end

	return nil
end

function Class:GetComponents(type)
	if self.gameObject then
		
	end
	
	return nil
end

function Class:GetComponentsInChildren(type)
	if self.gameObject then
		
	end
	
	return nil
end

function Class:GetComponentsInParent(type)
	if self.gameObject then
		
	end
	
	return nil
end