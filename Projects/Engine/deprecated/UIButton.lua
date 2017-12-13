local Class = class.NewClass("UIButton", "UIFrame")

function Class:New(parent)
	Class:Base().New(self, parent)

	self.colours.default:Set(35,35,35,255)
	self.colours.hover = Colour(100,35,35,255)

	self.OnPressEvent 		= Delegate()
	self.OnDragEvent 		= Delegate()
	self.OnReleaseEvent 	= Delegate()
	self.OnHoverEnterEvent 	= Delegate()
	self.OnHoverExitEvent 	= Delegate()
end

function Class:OnPress(x, y, button, istouch)
	self.OnPressEvent(self, x, y, istouch)
end

function Class:OnDrag(x, y, istouch)
	self.OnDragEvent(self, x, y, istouch)
end

function Class:OnRelease(x, y, button, istouch)
	self.OnReleaseEvent(self, x, y, button, istouch)
end

function Class:OnHoverEnter(x, y)
	self.OnHoverEnterEvent(self, x, y)
end

function Class:OnHoverExit(x, y)
	self.OnHoverExitEvent(self, x, y)
end