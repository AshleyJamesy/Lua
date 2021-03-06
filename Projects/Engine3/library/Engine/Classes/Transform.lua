local Class = class.NewClass("Transform", "Component")
Class.__limit = 1

function Class:New(gameObject, x, y)
	Class:Base().New(self, gameObject)

	self.parent 	= nil
	gameObject.scene.__roots[self:GetInstanceID()] = self
	
	self.transform 	= self
	
	self.children 	= {}

	self.scale 			= Vector2(1,1)
	self.position 		= Vector2(0,0)
	self.rotation 		= 0

	self.globalScale 	= Vector2(1,1)
	self.globalPosition = Vector2(0,0)
	self.globalRotation = 0

	self.localMatrix 	= Matrix3()
	self.globalMatrix 	= Matrix3()

	self.up 			= Vector2(0, 1)
	self.right 			= Vector2(1, 0)
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
	self.localMatrix:Transformation(self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
	
	if self.parent then
		local a = self.parent.globalMatrix
		local b = self.localMatrix
		
		self.globalMatrix:Set(
			a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31,
			a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32,
			a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33,
			a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31,
			a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32,
			a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33,
			a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31,
			a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32,
			a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33
		)
	else
		self.globalMatrix:Set(
			self.localMatrix:Unpack()
		)
	end
	
	self.globalRotation = self.globalMatrix:Rotation()
	self.globalPosition:Set(self.globalMatrix:Position())
	
	self.right:Set(self.globalMatrix:Right())
	self.up:Set(self.globalMatrix:Up())

	for k, v in pairs(self.children) do
		v:Update()
	end
end

--[[
function Class:New(gameObject, x, y)
	Class:Base().New(self, gameObject)
	
	self.parent 	= nil
	gameObject.scene.__roots[self:GetInstanceID()] = self
	
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
	self.globalScale:Set(self.scale.x, self.scale.y)
	
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
]]

--[[
function Class:OnDrawGizmos(camera)
	if Camera.main.transform ~= self and Camera.main == camera and camera.cameraType == CameraType.SceneView then
		local bounds = self.gameObject.__bounds

		love.graphics.setLineWidth(2.0)

		love.graphics.setColor(0,0,255,125)
		love.graphics.circle("line", self.globalPosition.x, self.globalPosition.y, 0.8 * math.abs(math.max(bounds.x - bounds.w, bounds.y - bounds.h)))
		
		love.graphics.setColor(255,0,0,125)
		love.graphics.line(self.globalPosition.x, self.globalPosition.y, self.globalPosition.x, self.globalPosition.y + 0.6 * (bounds.y - bounds.h))

		love.graphics.setColor(0,255,0,125)
		love.graphics.line(self.globalPosition.x, self.globalPosition.y, self.globalPosition.x - 0.6 * (bounds.x - bounds.w), self.globalPosition.y)

		love.graphics.setLineWidth(1.0)
	end
end
]]