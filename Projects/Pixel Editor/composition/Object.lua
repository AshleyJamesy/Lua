include("class")

local Class, BaseClass = class.NewClass("Object")
Object = Class
Object.count = 0

Class:IgnoreProperty("instanceId")

function Class:New()
	self.instanceId = Object.count

	self.hideflag   = {}
	self.name 		= self:Type()

	Object.count 	= Object.count + 1
end

function Class:GetInstanceId()
	return self.instanceId
end

function Class:ToString()
	return self.name
end