local Class = class.NewClass("UICanvas", "UIElement")

function Class:New(w, h)
	Class.Base.New(self)

	self.canvas = love.graphics.newCanvas(w, h)
	
	local w, h = self.canvas:getDimensions()
	self.rects.native.w = w
	self.rects.native.h = h
	
	hook.Add("OnMousePressed",	self, self.OnMousePressed)
	hook.Add("OnMouseReleased",	self, self.OnMouseReleased)
	hook.Add("OnMouseMoved",	self, self.OnMouseMoved)
	hook.Add("OnMouseWheel",	self, self.OnMouseWheel)
	hook.Add("OnWindowResize",	self, self.OnWindowResize)
end

function Class:Render()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
	
	self:Paint()
	
	love.graphics.setCanvas()
	love.graphics.setScissor()
	
	love.graphics.draw(self.canvas, 0, 0)
end