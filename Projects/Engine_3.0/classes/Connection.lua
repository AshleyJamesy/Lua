local Class = class.NewClass("Connection", "Object")

function Class:New(from, to)
	Class.Base.New(self)

	self.from 	= nil
	self.to 	= nil
	self.weight = 0
end