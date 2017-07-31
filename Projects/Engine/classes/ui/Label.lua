local Class = class.NewClass("Label", "UIElement")

function Class:New()
	Class.Base.New(self)
	self.colour = Colour(255,255,255,255)
	self.parentRect.w = 1.0
	self.parentRect.h = 1.0
	self.active = false
	self.text 	= ""
	self.align = "left"
end

function Class:Draw(w, h)
	love.graphics.setColor(self.colour:Unpack())
	love.graphics.printf(self.text, 0, 0, w, self.align)

	if ui.Debug then
		love.graphics.push()
		love.graphics.origin()
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("line", self.globalRect.x, self.globalRect.y, self.globalRect.w, self.globalRect.h)
		love.graphics.pop()
	end
end