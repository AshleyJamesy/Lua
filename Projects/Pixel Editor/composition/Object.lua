include("class")

local Class, BaseClass = class.NewClass("Object")
Object = Class
Object.count = 0

function Class:New()
	self.hideflag   = {}
	self.name		      = self:Type()
	self.instanceId = Object.count
	
	Object.count = Object.count + 1
end

function Class:GetInstanceId()
    return self.instanceId
end

function Class:ToString()
	return self.name
end