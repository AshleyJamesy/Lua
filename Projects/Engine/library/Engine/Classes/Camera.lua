local Class = class.NewClass("Camera", "Behaviour")

CameraType = enum{
	"Game", 		--Used to indicate a regular in-game camera.
	"SceneView", 	--Used to indicate that a camera is used for rendering the Scene View in the Editor.
	"Preview" 		--Used to indicate a camera that is used for rendering previews in the Editor.
}

function Class:New(gameObject, texture)
	Class:Base().New(self, gameObject)
	
	if Class.main then
	else
		Class.main = self
	end

	self.scene 				= gameObject.scene
	self.backgroundColour 	= Colour(75, 75, 75, 255)
	self.cameraType 		= CameraType.SceneView
	self.cullingMask 		= {}
	self.zoom 				= Vector2(1, 1)
	
	if texture == nil then 
		self.texture = Canvas()
	else
		self.texture = nil
	end

	self.bounds 			= Rect(0,0,0,0)
end

local ignore_table = { "Camera" }

local function grid(camera, w, h)
	--[[
	local w = (camera.texture and camera.texture:getWidth()  or love.graphics.getWidth()) 	* 0.5
 local h = (camera.texture and camera.texture:getHeight() or love.graphics.getHeight()) 	 * 0.5
	
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(0,0,0, 255)

	local sx 	= 100
	local sy 	= 100
	local c 	= 0

	for x = 0, (w * 2) / 100 do
		c = (math.floor(camera.transform.globalPosition.x / sx) * sx) + (x * sx) - w
		love.graphics.line(c, camera.transform.globalPosition.y - h, c, camera.transform.globalPosition.y + h)

		for y = 0, (h * 2) / 100 do
			c = (math.floor(camera.transform.globalPosition.y / sy) * sy) + (y * sy) - h
			love.graphics.line(camera.transform.globalPosition.x - w, c, camera.transform.globalPosition.x + w, c)
		end
	end
	]]

	local r,g,b,a = camera.backgroundColour:Unpack()
	love.graphics.setColor(a - r, a - g, a - b, 10)

    local zx = 100
    local zy = 100

    local ix = math.floor(w / zx)
    local iy = math.floor(h / zy)
    
    local cx = (0 * zx) - (camera.transform.globalPosition.x % zx)
    local cy = (0 * zy) - (camera.transform.globalPosition.y % zy) 

	for x = 0, ix do
		cx = (x * zx) - (camera.transform.globalPosition.x % zx)
		love.graphics.line(cx, 0, cx, h)

		for y = 0, iy do
			cy = (y * zy) - (camera.transform.globalPosition.y % zy)
			love.graphics.line(0, cy, w, cy)
		end
	end
end

--Public Methods
--[[
	TODO:
		Get all renderable objects
		Render
--]]
function Class:Render()
	
	--hook.Call("OnPreCull")			--Called before the camera culls the scene. Culling determines which objects are visible to the camera. OnPreCull is called just before culling takes place.
	--hook.Call("OnBecameVisible")		--Called when an object becomes visible/invisible to any camera.
	--hook.Call("OnBecameInvisible")	--Called when an object becomes visible/invisible to any camera.
	--hook.Call("OnWillRenderObject")	--Called once for each camera if the object is visible.
	--hook.Call("PreRender")			--Called before the camera starts rendering the scene.
	--hook.Call("OnRenderObject")		--Called after all regular scene rendering is done.
	--hook.Call("OnPostRender")			--Called after a camera finishes rendering the scene.
	--hook.Call("OnRenderImage")		--Called after scene rendering is complete to allow post-processing of the image

	--hook.Call("OnPreCull", self)
	--hook.Call("PreRender", self)
	
	love.graphics.push()
	
	local w = (self.texture and self.texture.width  or love.graphics.getWidth()) * 0.5
	local h = (self.texture and self.texture.height or love.graphics.getHeight()) * 0.5
	
	self.bounds:Set(self.transform.globalPosition.x - w, self.transform.globalPosition.y - h, w * 2, h * 2)
	
	love.graphics.translate(w, h)
	love.graphics.rotate(-self.transform.globalRotation)
	love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
	love.graphics.translate(-self.transform.globalPosition.x, -self.transform.globalPosition.y)

	--if texture then render to texture else render normally
	if self.texture then
		love.graphics.setCanvas(self.texture.source)
		love.graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)

		--Screen Space
		love.graphics.push()
		love.graphics.origin()

		if self.cameraType == CameraType.SceneView then
			self.transform.rotation = 0
			grid(self, w * 2, h * 2)
		end

		love.graphics.pop()

		love.graphics.setColor(255, 255, 255, 255)

		CallFunctionOnAll("Render", ignore_table, self)
		CallFunctionOnAll("OnDrawGizmos", nil, self)

		love.graphics.setCanvas()
	else
		love.graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)

		--Screen Space
		love.graphics.push()
		love.graphics.origin()

		if self.cameraType == CameraType.SceneView then
			self.transform.rotation = 0
			grid(self, w * 2, h * 2)
		end

		love.graphics.pop()

		love.graphics.setColor(255, 255, 255, 255)
		
		CallFunctionOnAll("Render", ignore_table, self)
		CallFunctionOnAll("OnDrawGizmos", nil, self)
	end

	love.graphics.pop()

	CallFunctionOnAll("OnRenderObject", self)
	CallFunctionOnAll("OnPostRender", self)

	love.graphics.setColor(255, 255, 255, 255)
end

function Class:OnDrawGizmos(camera)
	if Camera.main == camera and camera.cameraType == CameraType.SceneView then
	--if camera.cameraType == CameraType.SceneView and self.cameraType == CameraType.Game then
		--local w = (self.texture and self.texture.width  or love.graphics.getWidth()) * 0.5
		--local h = (self.texture and self.texture.height or love.graphics.getHeight()) * 0.5

		--love.graphics.rectangle("line", self.transform.globalPosition.x - w, self.transform.globalPosition.y - h, w * 2, h * 2)
		love.graphics.rectangle("line", self.bounds.x, self.bounds.y, self.bounds.w, self.bounds.h)
	end
end

function Class:ScreenToWorld(x, y)
	return (x * self.zoom.x + self.transform.globalPosition.x) - (self.texture and self.texture.width  or love.graphics.getWidth()) * 0.5 * self.zoom.x,
    	(y * self.zoom.y + self.transform.globalPosition.y) - (self.texture and self.texture.height or love.graphics.getHeight()) * 0.5 * self.zoom.y
end

function Class:WorldToScreen(x, y)

end

--Messages
--function Class:OnPostRender() 		end
--function Class:OnPreCull() 			end
--function Class:OnPostRender() 		end
--function Class:OnPreRender() 			end
--function Class:OnRenderImage() 		end
--function Class:OnRenderObject() 		end
--function Class:OnWillRenderObject() 	end