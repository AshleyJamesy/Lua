local Class = class.NewClass("loveforge.nodes.add", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetOutput("out", 0)
end

function Class:Update()
	self:SetOutput("out", Time.elapsed)
end