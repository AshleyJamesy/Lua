include("class")
include("composition/Behaviour")

local Class, BaseClass = class.NewClass("MonoBehaviour", "Behaviour")
MonoBehaviour = Class

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
function Class:Update() 		end
function Class:FixedUpdate()	end
function Class:LateUpdate()		end
function Class:OnEnabled()		end
function Class:OnDisable()		end
function Class:OnDestroy()		end