local Class = class.NewClass("Canvas")

function Class:New()
	self.source = love.graphics.newCanvas()
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
	self.wrt = self.width / self.height
	self.hrt = self.height / self.width
	self.rect 	= Rect(0, 0, self.width, self.height)
end

function Class:Render()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.source, self.rect.x, self.rect.y, 0, self.rect.w / self.width, self.rect.h / self.height)
	love.graphics.setBlendMode("alpha")
end