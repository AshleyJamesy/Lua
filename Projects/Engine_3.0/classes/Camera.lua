local Class = class.NewClass("Camera", "Object")

function Class:New()
	Class.Base.New(self)
	
	self.culling 	= {}
	self.background = Colour()
	self.canvas 	= nil
end

function Class:Render(group)
	love.graphics.setColor(255, 255, 255, 255)

	local offset = Vector2(0,0)

	if self.canvas then
		offset.x = self.canvas:getWidth() * 0.5
		offset.y = self.canvas:getHeight() * 0.5

		love.graphics.setCanvas(self.canvas)
	else
		offset.x = love.graphics.getWidth() * 0.5
		offset.y = love.graphics.getHeight() * 0.5
	end
	
	love.graphics.clear(self.background:Unpack())

	love.graphics.push()

	love.graphics.translate(offset.x, offset.y)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-self.position.x, -self.position.y)

	for k, v in pairs(group) do
		love.graphics.push()
		love.graphics.scale(v.scale.x, v.scale.y)
		love.graphics.rotate(v.rotation)
		love.graphics.translate(v.position.x, v.position.y)
		v:Render()
		love.graphics.pop()
	end

	love.graphics.pop()
	love.graphics.setCanvas()
end