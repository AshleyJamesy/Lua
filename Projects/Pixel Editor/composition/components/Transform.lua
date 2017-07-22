include("class")
include("math/Vector2")
include("composition/Component")

local Class, BaseClass = class.NewClass("Transform", "Component")
Transform = Class
Transform.sceneAdd = false

function Class:New(gameObject, parent)
	BaseClass.New(self, gameObject)
	--Only one transform per GameObject
	--TODO:
	self.multiple = 1
	
	self.transform = self
	
	--It either has a parent or it exists in scenes root
	self.parent		= parent or SceneManager.GetActiveScene().transform
	self.children	= {}
	self.scale 		= Vector2(1,1)
	self.rotation	= 0
	self.position 	= Vector2(0,0)
end

function Class:SetParent(transform)
	if transform then
		if transform == self then
			return
		end

		self.parent = transform
		self.parent:Attach(transform)
	else
		self.parent = SceneManager.GetActiveScene().transform
	end
end

function Class:Find(name)
	for _, transform in pairs(self.children) do
		if transform.name == name then
			return transform
		end
	end
end

function Class:Attach(transform)
	if transform then
		if transform == self then
			return
		end
		
		transform.parent = self
		table.insert(self.children, transform)
	end
end

function Class:RemoveChild(tranform)
	local found, index = table.HasValue(transform)

	if found then
		transform.parent = SceneManager.GetActiveScene().transform
		table.remove(self.children, index)
	end
end

function Class:RemoveChildAtIndex(index)
	if self.children[index] then
		self.children[index].parent = SceneManager.GetActiveScene().transform
		table.remove(self.children, index)
	end
end

function Class:Translate(x,y)
	if x and TypeOf(x) ~= "number" then
		self.position.x = self.position.x + x.x
		self.position.y = self.position.y + x.y
		return
	end

	self.position.x = self.position.x + x
	self.position.y = self.position.y + y
end

function Class:Up()
	return Vector2.Rotation(self.transform.rotation)
end

function Class:Right()
	return Vector2.Rotation(self.transform.rotation + 1.571)
end

function Class:Rotate(r)
	self.rotation = self.rotation + r
end

function Class:Update()
	
end