local Class = class.NewClass("loveforge.nodes.texture_asset", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetOutput("Tex", nil)
end

