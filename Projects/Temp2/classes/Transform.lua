local Class = class.NewClass("Transform", "Component")
Class.__limit = 1

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	if Class.Root then
		self.parent = Class.Root
		Class.Root.children[self.id] = self
	else
		self.parent = nil
	end
	
	self.transform = self

	self.children 	= Array{}

	self.scale 		= Vector2(1,1)
	self.rotation 	= 0
	self.position 	= Vector2(0,0)

	self.globalScale 	= Vector2(1,1)
	self.globalRotation = 0
	self.globalPosition = Vector2(0,0)

	self.__rotate = false
end

function Class:AddChild(child)
	if self == child then 
		return 
	end
	if self.children[child.id] then 
		return 
	end

	child.parent.children[child.id] = nil

	child.parent 			= self
	self.children[child.id] = child
end

function Class:RemoveChild(child)
	if self == child then 
		return 
	end
	if not self.children[child.id] then 
		return 
	end
	
	self.children[child.id] = nil
	
	child.parent = Class.Root
	Class.Root.children[child.id] = child
end

function Class:Update()
	if self.parent then
		self.globalRotation = self.parent.globalRotation + self.rotation
		self.globalPosition:Set(self.parent.globalPosition.x + self.position.x,  self.parent.globalPosition.y + self.position.y)
	else
		self.globalRotation = self.rotation
		self.globalPosition:Set(self.position.x, self.position.y)
	end
	
	for k, v in pairs(self.children) do
		v:Update()
	end
end

function Class:OnDrawGizmosSelected()
	--[[
	love.graphics.setLineWidth(3.0)
	love.graphics.setColor(0, 255, 0, 75)
	love.graphics.line(self.globalPosition.x, self.globalPosition.y, self.globalPosition.x + self.gameObject.__aabb.w * self.globalScale.x * 0.75, self.globalPosition.y)
	love.graphics.setColor(255, 0, 0, 75)
	love.graphics.line(self.globalPosition.x, self.globalPosition.y, self.globalPosition.x, self.globalPosition.y - self.gameObject.__aabb.h * self.globalScale.y * 0.75)
	love.graphics.setColor(0, 0, 255, 75)
	
	local radius = math.max(self.gameObject.__aabb.w, self.gameObject.__aabb.h) * math.max(self.globalScale.x, self.globalScale.y) * 0.95
	love.graphics.circle("line", self.globalPosition.x, self.globalPosition.y, radius)
	love.graphics.setLineWidth(1.0)
	]]
	
	--[[
	local v = (Vector2(Camera.main:ToWorld(love.mouse.getPosition())) - self.globalPosition)
	local m = v:Magnitude()

	if self.__rotate then
		self.rotation = v:ToAngle()
	else
		if m > radius and m < radius + 10 then
			if love.mouse.isDown(1) then
				self.__rotate = true
				Scene.main.a = true

				print("A")
			end
		end
	end
	]]
end

local function InitaliseClass()
	Class.Root = Transform()
end
hook.Add("InitaliseClass", "Transform", InitaliseClass)