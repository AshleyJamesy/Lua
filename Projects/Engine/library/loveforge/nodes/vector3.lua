local Class = class.NewClass("loveforge.nodes.vector3", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("x", 0.0)
	self:SetInput("y", 0.0)
	self:SetInput("z", 0.0)

	self:SetOutput("out", { 0.0, 0.0, 0.0 })
end

function Class:Update()
	self:SetOutput("out", 
		{
			self:GetInput("x"),
			self:GetInput("y"),
			self:GetInput("z")
		}
	)
end