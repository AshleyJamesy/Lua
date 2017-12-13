local Class = class.NewClass("Camera", "MonoBehaviour")

function Class:Awake()
	self.culling 	= {}
	self.background = Colour(0,0,0,255)
	self.target 	= nil

	hook.Add("Camera.Render", self, self.Render)
end

function Class:Render()
	love.graphics.setColor(255, 255, 255, 255)

	local offset = Vector2(0,0)

	if self.target then
		offset.x = self.target.width * 0.5
		offset.y = self.target.height * 0.5

		love.graphics.setCanvas(self.target.source)
	else
		offset.x = love.graphics.getWidth() * 0.5
		offset.y = love.graphics.getHeight() * 0.5
	end
	
	love.graphics.clear(self.background:Unpack())
	love.graphics.setBlendMode("alpha")

	love.graphics.push()
	love.graphics.translate(offset.x, offset.y)
	love.graphics.rotate(self.gameObject.rotation)
	love.graphics.translate(-self.gameObject.position.x, -self.gameObject.position.y)
	
	for k, v in pairs(SpriteRenderer.components) do
		v:Render()
	end

	love.graphics.pop()
	love.graphics.setCanvas()
end