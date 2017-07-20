include("class")

local Class, BaseClass = class.NewClass("Collider", "MonoBehaviour")
Collider = Class
Collider.sceneAdd = false

function Class:New(gameObject)
	BaseClass.New(self, gameObject)
	
	self.isTrigger		= false
	self.__collisions	= {}
	self.__triggers		= {}
end

function Class:CollisionEnter(collision)
	self:SendMessage("OnCollisionEnter", collision)
end

function Class:CollisionExit(collision)
	self:SendMessage("OnCollisionExit", collision)
end

function Class:CollisionStay(collision)
	self:SendMessage("OnCollisionStay", collision)
end

function Class:TriggerEnter(collider)
	self:SendMessage("OnTriggerEnter", collider)
end

function Class:TriggerExit(collider)
	self:SendMessage("OnTriggerExit", collider)
end

function Class:TriggerStay(collider)
	self:SendMessage("OnTriggerStay", collider)
end