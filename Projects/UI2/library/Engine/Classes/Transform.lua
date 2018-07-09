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
	
	self.globalScale = Vector2(1,1)
	self.globalPosition = Vector2(0,0)
	self.globalRotation = 0
	
	self.__cTransform = love.math.newTransform(x, y)
 
	self.bounds = Rect(0,0,0,0)
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

local m11, m12, m13, m14,
      m21, m22, m23, m24,
      m31, m32, m33, m34,
      m41, m42, m43, m44 = 0.0

function Class:Update()
 local cTransform = self.__cTransform
 local scale = self.scale
 local rotation = self.rotation
 local position = self.position
 	
 cTransform:setTransformation(position.x, position.y, rotation, scale.x, scale.y)	
 	
	if self.parent then
	    cTransform:apply(self.parent.__cTransform)
	end
	
	m11, m12, m13, m14,
	m21, m22, m23, m24,
	m31, m32, m33, m34,
	m41, m42, m43, m44 = cTransform:getMatrix()
	
	self.globalPosition:Set(m14, m24)
	
	self.bounds:Set(m14, m24, m14, m24)
	
	for k, v in pairs(self.children) do
		v:Update()
	end
end

function Class:OnDrawGizmos(camera)
	if Camera.main.transform ~= self and Camera.main == camera and camera.cameraType == CameraType.SceneView then
	    love.graphics.circle("fill", self.globalPosition.x, self.globalPosition.y, 3)
	end
end