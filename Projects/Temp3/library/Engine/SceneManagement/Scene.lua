local Class = class.NewClass("Scene")
Scene.active = nil

function Class:New(name)
	self.buildIndex = 0
	self.isDirty 	= false
	self.isLoaded 	= false
	self.name 		= name
end