include("class")


local Class, BaseClass = class.NewClass("Object")
Object = Class

function Class.Instantiate(object)
	
end

function Class:New()
	self.hideflag   = {}
	self.name		= self:Type()
end

function Class:ToString()
	return self.name
end