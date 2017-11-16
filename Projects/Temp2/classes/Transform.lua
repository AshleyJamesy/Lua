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

function Class:Gizmos()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.line(self.transform.globalPosition.x, self.transform.globalPosition.y, self.transform.globalPosition.x + 10, self.transform.globalPosition.y)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.line(self.transform.globalPosition.x, self.transform.globalPosition.y, self.transform.globalPosition.x, self.transform.globalPosition.y - 10)
end

local function InitaliseClass()
	Class.Root = Transform()
end
hook.Add("InitaliseClass", "Transform", InitaliseClass)