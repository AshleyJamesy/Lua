include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("RigidBody", "MonoBehaviour")
RigidBody = Class

RigidBody.Up 		= Vector2(0,-1)
RigidBody.gravity  	= 9.8 * 0.0

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

function Class:Update()
	self.velocity = self.velocity + -RigidBody.Up * RigidBody.gravity
	self.transform.position = self.transform.position + self.velocity
end