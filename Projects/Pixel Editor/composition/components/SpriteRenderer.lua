include("class")
include("composition/MonoBehaviour")
include("Colour")

local Class, BaseClass = class.NewClass("SpriteRenderer", "MonoBehaviour")
SpriteRenderer = Class
SpriteRenderer.sort 	=  function(a, b)
	return a.sortingIndex > b.sortingIndex
end

function Class:Awake()
	self.sortingIndex	= 0
	self.colour 		= Colour(0,255,0,255)
	self.sprite 		= nil
end

function Class:Render()
	
end