include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("MyComponent", "MonoBehaviour")

--[[
function Class:New(...)
	BaseClass.New(self, ...)
end
]]

function Class:Awake()
	self.transform.position.x = math.random() * love.graphics.getWidth()
	self.transform.position.y = math.random() * love.graphics.getHeight()
end

function Class:KeyPressed(key, scancode, isrepeat)
	
end

function Class:Update()
	if love.keyboard.isDown("w") then
		self.transform:Translate(0,-1)
	end
	if love.keyboard.isDown("s") then
		self.transform:Translate(0,1)
	end
	if love.keyboard.isDown("d") then
		self.transform:Translate(1,0)
	end
	if love.keyboard.isDown("a") then
		self.transform:Translate(-1,0)
	end
end

function Class:LateUpdate()

end

function Class:Render()
	love.graphics.circle("fill", self.transform.position.x, self.transform.position.y, 10)
end