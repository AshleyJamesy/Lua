local Class = class.NewClass("UIFrame", "UIElement")

function Class:New(parent)
	Class:Base().New(self, parent)

	self.colours.default:Set(55,55,55,255)
	self.scissor = false
end

function Class:RenderElement()
	love.graphics.rectangle("fill", self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)
	
	if self.scissor then
		love.graphics.intersectScissor(self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)
	end
end