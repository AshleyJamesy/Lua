include("class")
include("composition/Object")

local Class, BaseClass = class.NewClass("Sprite", "Object")
Sprite = Class
Sprite.Sprites = {}

function Class:New(path)
	self.image 		= love.graphics.newImage(path)
	self.pivot 		= Vector2(0.5,0.5)
	self.frames 	= {}
	self.animations = {}
	
	self.image:setFilter("nearest", "nearest")
end