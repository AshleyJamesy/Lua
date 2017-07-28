local Class = class.NewClass("Object")

function Class:New()
	self.hideflag   = {}
	self.name 		= self:Type()
end

--[[
	TODO:
		ensure when serialising objects that properties with classes are converted to a reference type
		when serialising if references[classtableid] == nil then serialise the property into references[classtableid]
		when a reference type is deserialised it will look for tableid in references[classtableid]
]]--
function Class:Serialise()

end

function Class:ToString()
	return self.name
end