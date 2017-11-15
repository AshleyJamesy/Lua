local Class = class.NewClass("Object")

function Class:New()
	self.hideflag 	= {}
	self.name 		= self:Type()
end

function Class:ToString()
	return self.name
end