local Class = class.NewClass("Camera", "Component")
Class.__limit = 1

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	if Camera.main then
	else
		Camera.main = self
	end
	
	self.culling	= {}
	self.background	= Colour(50, 80, 150, 255)
	self.zoom		= Vector2(1,1)
	self.canvas 	= nil
end

function Class:Render()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.push()
	
    local x = (self.canvas and canvas:getWidth()  or love.graphics.getWidth()) * 0.5
    local y = (self.canvas and canvas:getHeight() or love.graphics.getHeight()) * 0.5
    
    love.graphics.translate(x, y)
    love.graphics.rotate(-self.transform.rotation)
    love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
    love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
    
    --if canvas then render to canvas else render normally
	if self.canvas then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.background:Unpack())

		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		SendMessage("Render", { "Camera" })
		SendMessage("Gizmos", { "Camera" })

		love.graphics.setCanvas()
	else
		love.graphics.clear(self.background:Unpack())

		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		SendMessage("Render", { "Camera" })
		SendMessage("Gizmos", { "Camera" })
	end

	love.graphics.pop()
end

function Class:ToWorld(x, y)
    return (x * self.zoom.x + self.transform.globalPosition.x) - (self.canvas and canvas:getWidth()  or love.graphics.getWidth()) * 0.5 * self.zoom.x,
    	(y * self.zoom.y + self.transform.globalPosition.y) - (self.canvas and canvas:getHeight() or love.graphics.getHeight()) * 0.5 * self.zoom.y
end