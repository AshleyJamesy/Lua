local Class = class.NewClass("RigidBody", "Component")

function Class:New(gameObject)
	Class:Base().New(self, gameObject)
	
	self.mass 			= 1.0
	self.linearDrag 	= 0.0
	self.angularDrag	= 0.05
	self.gravityScale 	= 1.0
	self.isKinematic 	= false
	
	self.__body = love.physics.newBody(self.scene.__world, self.transform.globalPosition.x, self.transform.globalPosition.y, "static")
	self.__body:setUserData(self)
end

function Class:ApplyForce(fx, fy)
	self.__body.__body:applyForce(fx, fy)
end

function Class:ApplyForceAtPosition(fx, fy, x, y)
	self.__body.__body:applyForce(fx, fy, x, y)
end