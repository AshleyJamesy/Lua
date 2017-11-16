local Class = class.NewClass("Scene")

function Class:New()
	self.selected 	= nil
	self.objects 	= {}
end

function Class:Create(x, y)
	local g = GameObject(x, y)
	
	self.objects[g.id] = g
	return g
end