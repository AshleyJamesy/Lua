local Class = class.NewClass("Button", "UIElement")

function Class:New()
	Class.Base.New(self)

	self.colours = {
		active 		= Colour(35,35,35,255),
		down 		= Colour(35,35,35,255),
		hover  		= Colour(35,35,35,255),
		inactive 	= Colour(35,35,35,255)
	}
	self.colour = self.colours.active
	self.down 	= false

	self.label 	= ui.Create("Label", self)
end

function Class:Draw(w, h)
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

function Class:OnUpdate()
	if not self.active then
		self.colour = self.colours.inactive
	else
		if self.colour == self.colours.inactive then
			self.colour = self.colours.active
		end
	end
end

function Class:OnPress(x, y, button, istouch)
	if button == 1 or istouch then
		self.down = true
		self.colour = self.colours.down

		if self.DoPress then
			self:DoPress(x, y, button, istouch)
		end
	end
end

function Class:OnHover()
	if not self.down then
		self.colour = self.colours.hover
	end
end

function Class:OnHoverExit()
	self.colour = self.colours.active
end

function Class:OnDrag(x, y, istouch)
	if self.active and self.down or istouch then
		if self.DoDrag then
			self:DoDrag(x, y, istouch)
		end
	end
end

function Class:OnRelease(x, y, button, istouch)
	if self.active and button == 1 or istouch then
		self.down = false
		self.colour = self.colours.active
	end
end