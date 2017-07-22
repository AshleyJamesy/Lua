include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("RigidBody", "MonoBehaviour")
RigidBody = Class

function Class:Awake()
 self.type      = "static"
	self.velocity  = Vector2(0,0)
	self.colliders = {}
end

function Class:ComponentAdded(component)
    if component:IsType("Collider") then
        table.insert(self.colliders, component)
    end
end