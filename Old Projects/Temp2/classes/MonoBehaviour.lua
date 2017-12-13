local Class = class.NewClass("MonoBehaviour", "Behaviour")

function Class:Enable()
	if self.enabled then return end
	self.enabled = true
	self:OnEnable()
end

function Class:Disable()
	if not self.enabled then return end
	self.enabled = false
	self:OnDisable()
end

function Class:Update()

end

--Quicker to check for this function than loop through type
function Class:IsMonoBehaviour()
	return true
end