local Class = class.NewClass("Frame", "UIElement")

function Class:New()
	Class.Base.New(self)

	self.colours.default = Colour(55,55,55,255)
	self.colours.padding = Colour(55,55,55,255)
	self.colours.border  = Colour(25,25,25,255)

	self.colour = self.colours.default
end

function Class:Draw()
	--Content
	love.graphics.setColor(self.colours.border:Unpack())
	love.graphics.rectangle("fill", self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)

	--Border
	love.graphics.setColor(self.colours.default:Unpack())
	love.graphics.rectangle("fill", self.rects.border.x, self.rects.border.y, self.rects.border.w, self.rects.border.h)

	love.graphics.setColor(self.colours.padding:Unpack())
	love.graphics.rectangle("fill", self.rects.padding.x, self.rects.padding.y, self.rects.padding.w, self.rects.padding.h)

	--Padding
	love.graphics.intersectScissor(self.rects.padding.x, self.rects.padding.y, self.rects.padding.w, self.rects.padding.h)
end