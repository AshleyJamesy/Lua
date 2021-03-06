local Class = class.NewClass("Component", "Object")
Class.Components = {}

hook.Add("Initalise", class.GetClasses(), function(c)
	for k, v in pairs(c) do
		if v:IsType("Component") then
			table.insert(Class.Components, 1, k)
		end
	end
end)

function Class:New(gameObject)
	Class:Base().New(self)
	
	self.tag 		= ""
	
	self.__destroy 	= false

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
    return self.gameObject:GetComponent(typename)
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

function Class:SendMessage(method, reciever, ...)
    self.gameObject:SendMessage(method, reciever, ...)
end

function Class:SendMessageUpward(methodName, reciever, ...)
	
end

function Class:IsComponent()
	return true
end