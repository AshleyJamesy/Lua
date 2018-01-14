local Class = class.NewClass("loveforge.nodes.colour", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetOutput("RGB", { 0, 0, 0, 1.0 })
	self:SetOutput("R", 0.0)
	self:SetOutput("G", 0.0)
	self:SetOutput("B", 0.0)
	self:SetOutput("A", 1.0)
end