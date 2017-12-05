local Class = class.NewClass("Transform", "Component")
Class.__limit = 1

function Class:New(gameObject, x, y)
	Class:Base().New(self, gameObject)
	
	self.parent 	= nil
	gameObject.scene.__roots[self.__id] = self
	
	self.transform 	= self
	
	self.children 	= {}
	
	self.scale 		= Vector2(1, 1)
	self.rotation 	= 0
	self.position 	= Vector2(x, y)

	self.globalScale 	= Vector2(1, 1)
	self.globalRotation = 0
	self.globalPosition = Vector2(x, y)

	self.up 	= Vector2(0, 1)
	self.right 	= Vector2(1, 0)
end

function Class:AddChild(child)
	if self == child then 
		return 
	end
	if self.children[child.__id] then 
		return 
	end

	if child.parent then
		child.parent.children[child.__id] = nil
	else
		child.gameObject.scene.__roots[child.__id] = nil
	end

	child.parent 				= self
	self.children[child.__id] 	= child
end

function Class:RemoveChild(child)
	if self == child then 
		return 
	end
	if not self.children[child.__id] then 
		return 
	end
	
	self.children[child.__id] 	= nil
	child.parent 				= nil

	child.gameObject.scene.__roots[child.__id] = child
end

function Class:Update()
	local rb = self.gameObject.__rigidBody
	if rb then
		local body = self.gameObject.__body
		
		body:setMass(rb.mass)
		body:setLinearDamping(rb.linearDrag)
		body:setAngularDamping(rb.angularDrag)
		
		if rb.isKinematic then
			body:setType("kinematic")
		else
			body:setType("dynamic")
		end
		
		self.position.x = body:getX()
		self.position.y = body:getY()
		self.rotation 	= body:getAngle()
	end
	
	if self.parent then
		self.globalRotation = self.parent.globalRotation + self.rotation
		self.globalPosition:Set(self.parent.globalPosition.x + self.position.x,  self.parent.globalPosition.y + self.position.y)
	else
		self.globalRotation = self.rotation
		self.globalPosition:Set(self.position.x, self.position.y)
	end
	
	self.up 	= Vector2.Rotation(self.globalRotation + 0.0000)
	self.right 	= Vector2.Rotation(self.globalRotation + 1.5707)
	
	for k, v in pairs(self.children) do
		v:Update()
	end
end