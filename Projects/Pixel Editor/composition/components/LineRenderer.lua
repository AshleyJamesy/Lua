include("class")
include("composition/MonoBehaviour")
include("Colour")

local Class, BaseClass = class.NewClass("LineRenderer", "MonoBehaviour")
LineRenderer = Class
LineRenderer.sort 	=  function(a, b)
	return a.sortingIndex > b.sortingIndex
end

function Class:Awake()
	self.sortingIndex 	= 0
	self.colour 		= Colour(255,0,255,255)
end

function Class:Update()
	if love.keyboard.isDown("w") then
		self.transform:Translate(0, -1)
	end
	if love.keyboard.isDown("a") then
		self.transform:Translate(-1, 0)
	end
	if love.keyboard.isDown("s") then
		self.transform:Translate(0, 1)
	end
	if love.keyboard.isDown("d") then
		self.transform:Translate(1, 0)
	end
end

function Class:Render()
	love.graphics.setColor(self.colour:Unpack())
    love.graphics.rectangle("fill", self.transform.position.x, self.transform.position.y, 10, 10)
    love.graphics.setColor(255,255,255,255)
end