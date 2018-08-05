local Class = class.NewClass("Node")

function Class:New(x, y, w, h)
	self.position = Vector2(x, y)
	self.size = Vector2(w, h)

	self.inputs = {

	}

	self.processed = false
end

function Class:Render()
	love.graphics.setColor(0.4,0.4,0.4,1)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
end