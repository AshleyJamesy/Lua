local Class = class.NewClass("Component", "Object")
Class.limit = 0

function Class:New(gameObject)
	Class.Base.New(self)
	
	self.gameObject = gameObject
	
	self:SerialiseField("tag", "")
end

function Class:BroadcastMessage(method, ...)
	self.gameObject:BroadcastMessage(method, ...)
end

function Class:SendMessage(method, ...)
	self.gameObject:SendMessage(method, ...)
end

function Class:SendMessageUpwards(method, ...)
	
end

function Class:GetComponent(name)
	return self.gameObject:GetComponent(name)
end