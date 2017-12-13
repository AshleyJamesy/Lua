local Class = class.NewClass("Object")

function Class:New()
	self.__destroy = false
	
	self.scale		= Vector2(1,1)
	self.rotation	= 0
	self.position	= Vector2(0,0)
	
	self.parent 	= nil
	self.children	= {}
end

function Class:Update()
end

function Class:Render()
end

function Class:Destroy()
	self.__destroy = true
end