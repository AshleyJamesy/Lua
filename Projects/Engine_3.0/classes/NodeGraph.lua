local Class = class.NewClass("NodeGraph")

function Class:New()
	Class.Base.New(self)
	
	self.nodes = {}
end

