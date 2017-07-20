include("class")
include("composition/MonoBehaviour")
include("Colour")

local Class, BaseClass = class.NewClass("Camera", "MonoBehaviour")
Camera = Class
Camera.main = nil

local function Render(component, layer, camera)
	--return true so this batch is discarded since this camera is culling this layer
	if table.HasValue(camera.culling, layer.name) then
		return true
	end
	
	--return true so this batch is discarded since this type does not have a render function
	if not component["Render"] then
		return true
	end
	
    love.graphics.push()
    love.graphics.translate(component.transform.position.x, component.transform.position.y)
    love.graphics.push()
    love.graphics.rotate(component.transform.rotation)
    
    component:Render()
    
    love.graphics.pop()
    love.graphics.pop()
end

local function Gizmos(component, layer, camera)
	--return true so this batch is discarded since this camera is culling this layer
	if table.HasValue(camera.culling, layer.name) then
		return true
	end
	
	--return true so this batch is discarded since this type does not have a gizmos function
	if not component["Gizmos"] then
		return true
	end
	
	love.graphics.push()
    love.graphics.translate(component.transform.position.x, component.transform.position.y)
    love.graphics.push()
    love.graphics.rotate(component.transform.rotation)
    
    component:Gizmos()
    
    love.graphics.pop()
    love.graphics.pop()
end

function Class:Awake()
	if Camera.main then
	else
		Camera.main = self
	end
	
	self.culling	= {}
	self.background	= Colour(0,0,0,255)
	self.zoom		= Vector2(1,1)
	self.canvas 	= nil
end

function Class:Update()
	if love.keyboard.isDown("w") then
		self.transform:Translate(0,-1)
	end
	if love.keyboard.isDown("a") then
		self.transform:Translate(-1,0)
	end
	if love.keyboard.isDown("s") then
		self.transform:Translate(0,1)
	end
	if love.keyboard.isDown("d") then
		self.transform:Translate(1,0)
	end
end

function Class:Render()
	love.graphics.push()
	
	local vec = Vector2(0,0)
	vec.x = self.canvas and self.canvas:getWidth() or love.graphics.getWidth() * (1 / self.zoom.x) * 0.5
	vec.y = self.canvas and self.canvas:getHeight() or love.graphics.getHeight() * (1 / self.zoom.y) * 0.5
	
	love.graphics.scale(self.zoom.x, self.zoom.y)
	love.graphics.translate(vec.x, vec.y)
	love.graphics.rotate(self.transform.rotation)
	love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
	
	--if canvas then render to canvas else render normally
	if self.canvas then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.background:Unpack())
		--run function on all except camera types
		SceneManager.RunFunctionOnAll(Render, { "Camera" }, self)
		SceneManager.RunFunctionOnAll(Gizmos, { "Camera" }, self)
		love.graphics.setCanvas()
	else
		--run function on all except camera types
		SceneManager.RunFunctionOnAll(Render, { "Camera" }, self)
		SceneManager.RunFunctionOnAll(Gizmos, { "Camera" }, self)
	end
	
	love.graphics.pop()
end