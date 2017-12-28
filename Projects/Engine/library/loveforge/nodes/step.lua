local Class = class.NewClass("loveforge.nodes.step", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("A", 0)
	self:SetInput("B", 0)

	self:SetOutput("out", 0)
end

function Class:Update()
	self:SetOutput("out", self:GetInput("A") <= self:GetInput("B") and 1.0 or 0.0)
end