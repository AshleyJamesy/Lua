local Class = class.NewClass("Camera")

function Class:New(scene)
	self.scene    = scene
	self.position = Vector2(0,0)
	
	self.canvas = love.graphics.newCanvas(Screen.width, Screen.height)
end

function Class:Render(objects)
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
	love.graphics.translate(self.position.x, self.position.y)
	
	for k, v in pairs(self.scene) do
		if v.Render then
			v:Render()
		end
	end
	
	love.graphics.origin()
	for k, v in pairs(self.scene) do
		if v.RenderUI then
			v:RenderUI()
		end
	end
	
	love.graphics.pop()
	
	love.graphics.setCanvas()
end

hook.Add("WindowResize", "Screen", function(w, h)
	self.canvas = love.graphics.newCanvas(w, h)
end)

function Class:Show()
	love.graphics.reset()
	Screen.Draw(self.canvas, 0.0, 0.0, 0.0)
end