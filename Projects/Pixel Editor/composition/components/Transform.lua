include("class")
include("math/Vector2")
include("composition/Component")

local Class, BaseClass = class.NewClass("Transform", "Component")
Transform = Class

function Class:New(gameObject)
	BaseClass.New(self, gameObject)

	if gameObject then
		self.transform = self
	end
	
	--Only one transform per GameObject
	self.__multiple = 1
	
	self.root 		= nil
	self.parent		= nil
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