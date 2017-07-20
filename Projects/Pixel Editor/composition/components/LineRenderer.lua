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
	self.colour 		= Colour(255,255,255,255)
end

function Class:Render()
	love.graphics.setColor(self.colour:Unpack())
    love.graphics.rectangle("fill", self.transform.position.x - 5, self.transform.position.y - 5, 10, 10)
    love.graphics.setColor(255,255,255,255)
end