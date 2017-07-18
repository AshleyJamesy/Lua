include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("MyComponent", "MonoBehaviour")

function Class:Awake()
	self.transform.position.x = math.random() * love.graphics.getWidth()
	self.transform.position.y = math.random() * love.graphics.getHeight()
	self.target = Vector2(self.transform.position)
end

function Class:MousePressed(x, y, button, istouch)
	self.transform.position.x = math.random() * love.graphics.getWidth()
	self.transform.position.y = math.random() * love.graphics.getHeight()
	self.target:Set(x,y)
end

function Class:Update()
	self.transform.position = Vector2.Lerp(self.transform.position, self.target, Time.delta)
end

function Class:Render()
	love.graphics.circle("fill", self.transform.position.x, self.transform.position.y, 10)
end