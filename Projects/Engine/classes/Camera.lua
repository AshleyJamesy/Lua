local Class = class.NewClass("Camera", "MonoBehaviour")
Class.main = nil

local function Render(component, layer, camera)
	--return true so this batch is discarded since this type does not have a render function
	if not component.Render then return true end
	
	love.graphics.push()
	love.graphics.translate(component.transform.position.x, component.transform.position.y)
	love.graphics.rotate(component.transform.rotation)
	love.graphics.scale(component.transform.scale.x, component.transform.scale.y)
	
	component:Render()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.pop()
end

function Class:Awake()
	if Class.main then
	else
		Class.main = self
	end
	
	self.culling	= {}
	self.background	= Colour(50, 80, 150, 255)
	self.zoom		= Vector2(1,1)
	self.canvas 	= nil
end

function Class:Render()
	--Sorting
	--[[
	for layerid, layer in pairs(Scene.main.layers) do
		if table.HasValue(self.culling, layer.name) then
		else
			for type_name, batch in pairs(layer.components) do
				for index, component in pairs(batch) do
					if component.Render then
						if component.Sort then
							layer:Sort(type_name, component.Sort)
							break
						end
					end
					break
				end
			end
		end
	end
	]]
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.push()

	local offset = Vector2(0,0)
    offset.x = (self.canvas and canvas:getWidth()  or love.graphics.getWidth())  * 0.5
    offset.y = (self.canvas and canvas:getHeight() or love.graphics.getHeight()) * 0.5
    
    love.graphics.translate(offset.x, offset.y)
    love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
    love.graphics.rotate(self.transform.rotation)
    love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
    
	--if canvas then render to canvas else render normally
	if self.canvas then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.background:Unpack())
		
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		--run function on all except camera types and culled layers
		for k, v in pairs(Scene.main.layers) do
			if table.HasValue(self.culling, v.name) then
			else
				v:RunFunctionOnAll(Render, { "Camera" }, v, self)
			end
		end

		love.graphics.setCanvas()
	else
		love.graphics.clear(self.background:Unpack())
		
		love.graphics.line(-100, 0, 100, 0)
		love.graphics.line(0, -100, 0, 100)

		--run function on all except camera types and culled layers
		for k, v in pairs(Scene.main.layers) do
			if table.HasValue(self.culling, v.name) then
			else
				v:RunFunctionOnAll(Render, { "Camera" }, v, self)
			end
		end
	end

	love.graphics.pop()
end

function Class:Gizmos()
	
end