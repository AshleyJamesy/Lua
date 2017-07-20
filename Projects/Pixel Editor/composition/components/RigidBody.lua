include("class")
include("composition/MonoBehaviour")
include("Colour")

local Class, BaseClass = class.NewClass("RigidBody", "MonoBehaviour")
RigidBody = Class

function Class:Awake()
	self.velocity = Vector2(0,0)
end

function Class:Render()
	
end