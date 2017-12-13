local Class = class.NewClass("RectTransform", "Rect")

function Class:New(x, y, w, h)
	Rect.New(self, x, y, w, h)
end