local Class = class.NewClass("Object")

function Class.Instantiate(object)
	local object = class.DeSerialise(object)
	
	return object
end

function Class:New()
	self:SerialiseField("hideflag", {})
	self:SerialiseField("name", 	self:Type())
end

function Class:ToString()
	return self.name
end