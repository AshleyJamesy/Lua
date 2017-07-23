include("class")
include("types/Colour")
include("composition/MonoBehaviour")

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
	love.graphics.rotate(component.transform.rotation)
	love.graphics.scale(component.transform.scale.x, component.transform.scale.y)
	
	component:Render()
	
	love.graphics.setColor(255,255,255,255)

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
	love.graphics.rotate(component.transform.rotation)
	love.graphics.scale(component.transform.scale.x, component.transform.scale.y)

	component:Gizmos()
	
	love.graphics.setColor(255,255,255,255)
	
	love.graphics.pop()
end

function Class:Awake()
	if Camera.main then
	else
		Camera.main = self
	end
	
	self.culling	= {}
	self.background	= Colour(50, 80, 150, 255)
	self.zoom		= Vector2(1,1)
	self.canvas 	= nil
end

function Class:ToScreenPosition(x, y)
	
end

function Class:ToWorldPosition(x, y)
	
end

function Class:Render()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.push()

	local vec = Vector2(0,0)
    vec.x = (self.canvas and canvas:getWidth()  or love.graphics.getWidth()) * 0.5
    vec.y = (self.canvas and canvas:getHeight() or love.graphics.getHeight()) * 0.5
    
    love.graphics.translate(vec.x, vec.y)
    love.graphics.rotate(-self.transform.rotation)
    love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
    love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
    
	--if canvas then render to canvas else render normally
	if self.canvas then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.background:Unpack())
		--run function on all except camera types
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		SceneManager.RunFunctionOnAll(Render, { "Camera" }, self)
		SceneManager.RunFunctionOnAll(Gizmos, nil, self)
		love.graphics.setCanvas()
	else
		love.graphics.clear(self.background:Unpack())
		--run function on all except camera types
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		SceneManager.RunFunctionOnAll(Render, { "Camera" }, self)
		SceneManager.RunFunctionOnAll(Gizmos, nil, self)
	end

	love.graphics.pop()
end

function Class:Gizmos()

end