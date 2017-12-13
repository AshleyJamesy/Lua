local Class = class.NewClass("Transform", "Component")
Class.limit = 1

function Class:New(gameObject)
	Class.Base.New(self, gameObject)

	self.transform	= self
	self.parent		= nil
	self.children	= {}
	
	self:SerialiseField("scale", Vector2(1,1))
	self:SerialiseField("rotation", 0)
	self:SerialiseField("position", Vector2(0,0))
end

function Class:SetParent(transform)
	if transform then
		if transform == self then
			return
		end

		self.parent = transform
		self.parent:Attach(transform)
	else
		self.parent = nil
	end
end

function Class:Find(name)
	for _, transform in pairs(self.children) do
		if name == transform.gameObject.name then
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
		transform.parent = nil
		table.remove(self.children, index)
	end
end

function Class:RemoveChildAtIndex(index)
	if self.children[index] then
		self.children[index].parent = nil
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

--TODO: update children global positions and local positions
function Class:Update()
	
end