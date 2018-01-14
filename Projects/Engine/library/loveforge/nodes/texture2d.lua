local Class = class.NewClass("loveforge.nodes.texture2d", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("UV", nil)
	self:SetInput("Tex", nil)
	
	self:SetOutput("RGB", { 0, 0, 0, 1.0 })
end

function Class:Update()
	
end