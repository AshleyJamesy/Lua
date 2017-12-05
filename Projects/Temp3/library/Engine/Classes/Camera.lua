local Class = class.NewClass("Camera", "Behaviour")

CameraType = enum{
	"Game", 		--Used to indicate a regular in-game camera.
	"SceneView", 	--Used to indicate that a camera is used for rendering the Scene View in the Editor.
	"Preview" 		--Used to indicate a camera that is used for rendering previews in the Editor.
}

function Class:New(gameObject)
	Class:Base().New(self, gameObject)
	
	if Class.main then
	else
		Class.main = self
	end

	self.scene 				= gameObject.scene
	self.backgroundColour 	= Colour(73, 73, 73, 255)
	self.cameraType 		= CameraType.SceneView
	self.cullingMask 		= {}
	self.zoom 				= Vector2(1, 1)
	self.texture 			= love.graphics.newCanvas()
end

local ignore_table = { "Camera" }

local function grid(camera)
	local w = (camera.texture and camera.texture:getWidth()  or love.graphics.getWidth()) * 0.5
    local h = (camera.texture and camera.texture:getHeight() or love.graphics.getHeight()) * 0.5

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
	
	hook.Call("OnPreCull", self)
	hook.Call("PreRender", self)
	
	love.graphics.push()
	
	local w = (self.texture and self.texture:getWidth()  or love.graphics.getWidth()) * 0.5
	local h = (self.texture and self.texture:getHeight() or love.graphics.getHeight()) * 0.5
	
	love.graphics.translate(w, h)
	love.graphics.rotate(-self.transform.globalRotation)
	love.graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
	love.graphics.translate(-self.transform.globalPosition.x, -self.transform.globalPosition.y)
	
	--if texture then render to texture else render normally
	if self.texture then
		love.graphics.setCanvas(self.texture)
		love.graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)

		--love.graphics.push()
		--love.graphics.origin()

		if self.cameraType == CameraType.SceneView then
			grid(self)
		end

		--love.graphics.pop()

		love.graphics.setColor(255, 255, 255, 255)

		CallFunctionOnAll("Render", ignore_table, self)
		CallFunctionOnAll("OnDrawGizmos", nil, self)

		love.graphics.setCanvas()
	else
		love.graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)

		if self.cameraType == CameraType.SceneView then
			grid(self)
		end

		love.graphics.setColor(255, 255, 255, 255)
		
		CallFunctionOnAll("Render", ignore_table, self)
		CallFunctionOnAll("OnDrawGizmos", nil, self)
	end

	love.graphics.pop()

	hook.Call("OnRenderObject", self)
	hook.Call("OnPostRender", self)
end

function Class:OnDrawGizmos(camera)
	if self ~= camera then
		love.graphics.circle("fill", self.transform.position.x, self.transform.position.y, 10)
	end
end

function Class:ScreenToWorld(x, y)
	return (x * self.zoom.x + self.transform.globalPosition.x) - (self.texture and self.texture:getWidth()  or love.graphics.getWidth()) * 0.5 * self.zoom.x,
    	(y * self.zoom.y + self.transform.globalPosition.y) - (self.texture and self.texture:getHeight() or love.graphics.getHeight()) * 0.5 * self.zoom.y
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