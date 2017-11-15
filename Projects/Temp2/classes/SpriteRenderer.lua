local Class = class.NewClass("SpriteRenderer", "MonoBehaviour")

function Class:New(gameObject, ...)
	Class:Base().New(self, gameObject, ...)
end

function Class:Awake()
	self.sortingIndex 		= 0
	self.speed 				= 1.0
	self.animation_index 	= 1
	self.timer 				= 0.0
	self.animation 			= ""
	self.playing 			= false
	self.xflip 				= 0
	self.yflip 				= 0
	--self.colour = 
end

function Class:Update()
	
end

function Class:Render()
	love.graphics.rectangle("fill", self.gameObject.transform.position.x, self.gameObject.transform.position.y, 100, 100)
end