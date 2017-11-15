local Class = class.NewClass("MonoBehaviour", "Behaviour")

function Class:New(gameObject, ...)
	Class:Base().New(self, gameObject, ...)
end

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

--Virtual Functions
function Class:Awake()			end
function Class:Start()			end
function Class:OnEnable()		end
function Class:OnDisable()		end
function Class:OnDestroy()		end

--Quicker to check for this function than loop through type
function Class:IsMonoBehaviour()
	return true
end