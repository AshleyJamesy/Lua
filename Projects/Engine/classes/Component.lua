local Class = class.NewClass("Component", "Object")
Class.limit = 0

function Class:New(gameObject)
	Class.Base.New(self)
	
	self.gameObject = gameObject
	self.tag = ""
	
	self.transform = (gameObject and gameObject.transform) and gameObject.transform or nil
	
	hook.Call("ComponentInitalised", self)
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
	return self.gameObject:GetComponent(type)
end