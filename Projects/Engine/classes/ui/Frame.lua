local Class = class.NewClass("Frame", "UIElement")

function Class:New()
	Class.Base.New(self)

	self.colour = Colour(55,55,55,255)
end

function Class:Draw(w, h)
	--love.graphics.intersectScissor(self.globalRect.x, self.globalRect.y, self.globalRect.w, self.globalRect.h)
	love.graphics.setColor(self.colour:Unpack())
	love.graphics.rectangle("fill", 0, 0, w, h)

	if ui.Debug then
		love.graphics.push()
		love.graphics.origin()
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("line", self.globalRect.x, self.globalRect.y, self.globalRect.w, self.globalRect.h)
		love.graphics.pop()
	end
end