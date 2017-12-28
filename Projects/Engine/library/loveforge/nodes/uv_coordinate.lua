local Class = class.NewClass("loveforge.nodes.uv_coordinate", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetOutput("UV", { 0, 0 })
	self:SetOutput("U", 0)
	self:SetOutput("V", 0)
end

