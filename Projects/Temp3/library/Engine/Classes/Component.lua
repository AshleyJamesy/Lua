local Class = class.NewClass("Component", "Object")

function Class:New(gameObject)
	Class:Base().New(self, gameObject.__id)
	
	self.tag 		= ""
	
	--Set by GameObject:AddComponent
	--self.gameObject 	= gameObject
	--self.transform 	= gameObject and gameObject.transform or nil
end

function Class:BroadcastMessage(methodName, reciever, ...)
	
end

function Class:CompareTag(tag)
	return self.tag == tag
end

function Class:GetComponent(typename)
	
end

function Class:GetComponentInChildren(typename)
	
end

function Class:GetComponentInParent(typename)
	
end

function Class:GetComponents(typename)
	
end

function Class:GetComponentsInChildren(typename)
	
end

function Class:GetComponentsInParent(typename)
	
end

function Class:SendMessage(methodName, reciever, ...)
	
end

function Class:SendMessageUpward(methodName, reciever, ...)
	
end

function Class:IsComponent()
	return true
end