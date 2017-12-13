local Class = class.NewClass("Canvas", "UIElement")

function Class:New(w, h)
	UIElement.New(self)

	self.canvas = love.graphics.newCanvas(w, h)
	
	local w, h = self.canvas:getDimensions()
	self.w = w
	self.h = h
	
	hook.Add("OnMousePressed",	self, self.OnMousePressed)
	hook.Add("OnMouseReleased",	self, self.OnMouseReleased)
	hook.Add("OnMouseMoved",	self, self.OnMouseMoved)
	hook.Add("OnMouseWheel",	self, self.OnMouseWheel)
	hook.Add("OnWindowResize",	self, self.OnWindowResize)
	hook.Add("Update", 			self, self.Update)
end

function Class:Render()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0,0,0,0)
	
	self:Paint()
	
	love.graphics.setCanvas()
	love.graphics.setScissor()
	
	love.graphics.draw(self.canvas, 0, 0)
end