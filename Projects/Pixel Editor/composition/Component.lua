include("class")
include("composition/Object")
include("composition/scene/SceneManager")

local Class, BaseClass = class.NewClass("Component", "Object")
Component = Class

function Class:New(gameObject)
	BaseClass.New(self)
	
	self.gameObject = gameObject
	self.tag 		= ""
	self.transform	= gameObject.transform
	
	--TODO: Limits
	self.__multiple = 1

	SceneManager.GetActiveScene():AddComponent(self)
end

function Class:BroadcastMessage(method, require, ...)

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

function Class:SendMessage(method, require, ...)
	
end

function Class:SendMessageUpwards(method, require, ...)
	
end