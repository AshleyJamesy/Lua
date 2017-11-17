local Class = class.NewClass("Rect")

function Class:New(x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
end