include("class")
include("math/Vector2")
include("composition/Component")

local Class, BaseClass = class.NewClass("Transform", "Component")
Transform = Class

function Class:New(gameObject, parent)
	BaseClass.New(self, gameObject, false)

	self.transform = self
	
	--Only one transform per GameObject
	--TODO:
	self.multiple = 1
	
	--It either has a parent or it exists in scenes root
	self.parent		= parent or SceneManager.GetActiveScene().transform
	self.children	= {}
	self.scale 		= Vector2(0,0)
	self.rotation	= 0
	self.position 	= Vector2(0,0)
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

function Class:Rotate(r)
	self.rotation = self.rotation + r
end

function Class:Update()

end