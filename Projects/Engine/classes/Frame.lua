local Class = class.NewClass("Frame")

function Class:New(sprite)
	self.colour = Colour(45,45,45,255)
	self:Skin(sprite)
end

function Class:Skin(sprite)
	if sprite then
		self.sprite = sprite
		self.quads = {}
		local w, h = sprite.image:getDimensions()
		for i = 0, 2 do
			for j = 0, 2 do
				local quad = love.graphics.newQuad(i * (w/3), j * (w/3), w/3, h/3, w, h)
				table.insert(self.quads, quad)
			end
		end
	end
end

function Class:Render()
	c = Colour(love.graphics.getColor())
	love.graphics.setColor(self.colour:Unpack())

	if self.quads then
		love.graphics.draw(self.sprite.image, self.quads[1], 100, 100, 0, 2, 2)
	end

	love.graphics.setColor(c:Unpack())
end