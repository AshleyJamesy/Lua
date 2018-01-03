local Class = class.NewClass("Canvas")

function Class:New(w, h)
	self.source = love.graphics.newCanvas(Screen.width, Screen.height)
	self.width  = self.source:getWidth()
	self.height = self.source:getHeight()
	
	hook.Add("WindowResize", self, Class.OnWindowResize)
end

function Class:OnWindowResize(w, h)
    self.source = love.graphics.newCanvas(w, h)
    self.width  = w
    self.height = h
end