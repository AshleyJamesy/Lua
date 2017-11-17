local Class = class.NewClass("Camera", "Behaviour")
Class.__limit = 1

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	Class.main = self
	
	self.culling	= {}
	self.background	= Colour(73, 73, 73, 255)
	self.zoom		= Vector2(1,1)
	self.canvas 	= nil
	self.enabled 	= true

	self.scene 		= Scene.main
end

--[[
	TODO:
	Fix Zooming
]]
local function grid(camera)
	local w = (camera.canvas and camera.canvas:GetWidth()  or love.graphics.getWidth()) * 0.5
    local h = (camera.canvas and camera.canvas:GetHeight() or love.graphics.getHeight()) * 0.5

	love.graphics.setColor(255, 255, 255, 20)
	local sx 	= 100 * camera.zoom.x
	local sy 	= 100 * camera.zoom.y
	local c 	= 0
	for x = 0, (w * 2) / 100 do
		c = (math.floor(camera.transform.globalPosition.x / sx) * sx) + (x * sx) - w
		love.graphics.line(c, camera.transform.globalPosition.y - h, c, camera.transform.globalPosition.y + h)

		for y = 0, (h * 2) / 100 do
			c = (math.floor(camera.transform.globalPosition.y / sy) * sy) + (y * sy) - h
			love.graphics.line(camera.transform.globalPosition.x - w, c, camera.transform.globalPosition.x + w, c)
		end
	end
end

function Class:Render()
	love.graphics.push()
	
    local w = (self.canvas and self.canvas:GetWidth()  or love.graphics.getWidth()) * 0.5
    local h = (self.canvas and self.canvas:GetHeight() or love.graphics.getHeight()) * 0.5
    
    love.graphics.translate(w, h)
    love.graphics.rotate(-self.transform.rotation)
    love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
    love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
    
    --if canvas then render to canvas else render normally
	if self.canvas then
		love.graphics.setCanvas(self.canvas.source)
		love.graphics.clear(self.background:Unpack())

		love.graphics.push()
		love.graphics.origin()

		grid(self)

		love.graphics.pop()
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		love.graphics.setColor(255, 255, 255, 255)
		SendMessage("Render", { "Camera" })

		love.graphics.draw(Sprite("resources/sprites/hero.png").batch)

		if Camera.main == self then
			SendMessage("OnDrawGizmos")
		end

		if Scene.main then
			Scene.main:Render()
		end

		love.graphics.setCanvas()
	else
		love.graphics.clear(self.background:Unpack())

		grid(self)
		
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		love.graphics.setColor(255, 255, 255, 255)
		SendMessage("Render", { "Camera" })

		love.graphics.draw(Sprite("resources/sprites/hero.png").batch)

		if Camera.main == self then
			SendMessage("OnDrawGizmos")
		end

		if Scene.main then
			Scene.main:Render()
		end
	end

	love.graphics.pop()
end

function Class:Update()
	self.zoom.x = math.clamp(self.zoom.x, 0, math.huge)
	self.zoom.y = math.clamp(self.zoom.y, 0, math.huge)

	if Camera.main == self then
		local w = love.keyboard.isDown("w")
		local a = love.keyboard.isDown("a")
		local s = love.keyboard.isDown("s")
		local d = love.keyboard.isDown("d")

		local speed = 100

		if love.keyboard.isDown("lshift") then
			speed = 500
		end

		if a and d then
		elseif a or d then
			self.transform.position.x = self.transform.position.x + (a and -speed or speed) * Time.delta
		else
		end

		if w and s then
		elseif w or s then
			self.transform.position.y = self.transform.position.y + (w and -speed or speed) * Time.delta
		else
		end
	end
end

function Class:WindowResize(w, h)
	if self.canvas then
		self.canvas.source = love.graphics.newCanvas(w, h)
	end
end

function Class:OnDrawGizmos()
	local w, h = (self.canvas and self.canvas:GetWidth()  or love.graphics.getWidth()) * self.zoom.x, (self.canvas and self.canvas:GetHeight() or love.graphics.getHeight()) * self.zoom.y

	love.graphics.rectangle("line", self.transform.globalPosition.x - w * 0.5, self.transform.globalPosition.y - h * 0.5, w, h)
end

function Class:ToWorld(x, y)
    return (x * self.zoom.x + self.transform.globalPosition.x) - (self.canvas and self.canvas:GetWidth()  or love.graphics.getWidth()) * 0.5 * self.zoom.x,
    	(y * self.zoom.y + self.transform.globalPosition.y) - (self.canvas and self.canvas:GetHeight() or love.graphics.getHeight()) * 0.5 * self.zoom.y
end