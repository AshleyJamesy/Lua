local Class = class.NewClass("loveforge.nodes.remap_simple", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("in", 0.0)
	self:SetInput("out", 0.0)

	self.from 	= { 0, 1 }
	self.to 	= { -1, 1 }
end

function Class:Compile()
	
end