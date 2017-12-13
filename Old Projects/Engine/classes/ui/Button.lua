local Class = class.NewClass("Button", "Frame")

function Class:New()
	Class.Base.New(self)

	self.colours.default = Colour(35,35,35,255)
	self.colours.padding = Colour(35,35,35,255)
	self.colours.border  = Colour(35,35,35,255)

	self.colour = self.colours.default
end

function Class:Draw()
	Class.Base.Draw(self)
end