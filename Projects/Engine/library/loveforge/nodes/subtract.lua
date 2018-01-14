local Class = class.NewClass("loveforge.nodes.subtract", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("A", 0)
	self:SetInput("B", 0)

	self:SetOutput("out", 0)
end

function Class:Update()
	self:SetOutput("out", self:GetInput("A") - self:GetInput("B"))
end