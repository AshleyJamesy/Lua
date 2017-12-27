local function grid(camera, w, h, unit)
	--[[
		TODO: Subdivisons
	]]
	local r,g,b,a = camera.backgroundColour:Unpack()
	graphics.setLineStyle("rough")
	graphics.setColor(a - r, a - g, a - b, 10)

	local unit = unit or 100

	local ix = math.floor(w / unit)
	local iy = math.floor(h / unit)
	
	local cx = (0 * unit) - (camera.transform.globalPosition.x % unit)
	local cy = (0 * unit) - (camera.transform.globalPosition.y % unit) 

	for x = 0, ix do
		cx = (x * unit) - (camera.transform.globalPosition.x % unit)
		graphics.line(cx, 0, cx, h)

		for y = 0, iy do
			cy = (y * unit) - (camera.transform.globalPosition.y % unit)
			graphics.line(0, cy, w, cy)
		end
	end

	graphics.setColor(255, 255, 255, 255)
	graphics.setLineStyle("smooth")
end

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
	self.backgroundColour 	= Colour(75, 75, 75, 255)
	self.cameraType 		= CameraType.SceneView
	self.cullingMask 		= {}
	self.zoom 				= Vector2(1, 1)
	
	self.canvases = 
	{
		colour 		= Canvas(),
		emission 	= Canvas(),
		post 		= Canvas()
	}
	
	self.bounds = Rect(0,0,0,0)
end

--Public Methods
--[[
	TODO:
		Get all renderable objects
		Render
--]]

local ignore_table 	= { "Camera" }

local function DoRender(camera, w, h)
	graphics.setColor(255, 255, 255, 255)
	
	--CallFunctionOnAll("Render", ignore_table, camera)
	
	for name, batch in pairs(SceneManager:GetActiveScene().__objects) do
			if table.HasValue(ignore_table, name) then
			else
			    if batch then
	    		    local f = nil
		    	    local index, component = next(batch, nil)
		    	    local post = nil
		    	    
		    	    while index do
			            if f == nil then
			                f = component["Render"]
			                
			                if f == nil or type(f) ~= "function" then
	    		                f = nil
	    		                break
		    	            end
		    	            
		    	            if component.PreRender then
		    	                component.PreRender(camera)
		    	            end
		    	            
		    	            post = component.PostRender
		    	        end
			        
		    	        if component.enabled == nil or component.enabled == true then
		    	            f(component, camera)
		    	        end
			            
	    		        index, component = next(batch, index)
	    		        
	    		        if index == nil then
	    		            if post then
		    	                post(camera)
		    	                post = nil
		    	            end
	    		        end
			       end
			    end
			end
 end
	
	graphics.push()
	graphics.origin()
	
	CallFunctionOnAll("RenderUI", ignore_table, camera)
	
	graphics.pop()
	
	CallFunctionOnAll("OnDrawGizmos", nil, camera)

	graphics.setColor(255, 255, 255, 255)
end

local effect_canvas = love.graphics.newCanvas()

function blur(target, x, y, passes, intensity)
	local old 				= love.graphics.getCanvas()
	local shader 			= love.graphics.getShader()
	local mode, alphamode 	= love.graphics.getBlendMode()
	local r,g,b,a 			= love.graphics.getColor()

	love.graphics.setCanvas(effect_canvas)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,255)

 local blurv = Shader("resources/shaders/blurv.glsl")
 local blurh = Shader("resources/shaders/blurh.glsl")
	
	for i = 1, passes do
		love.graphics.setCanvas(effect_canvas)
		love.graphics.clear()
		blurv:Send("screen", Screen.Dimensions)
		blurv:Send("steps", x and x > 0 and x or 1.0)
		blurv:Send("intensity", 1.0 + intensity * 0.01)
		blurv:Use()
		love.graphics.draw(target)
		
		love.graphics.setCanvas(target)
		blurh:Send("screen", Screen.Dimensions)
		blurh:Send("steps", y and y > 0 and y or 1.0)
		blurh:Send("intensity", 1.0 + intensity * 0.01)
		blurh:Use()

		love.graphics.draw(effect_canvas)
	end
	
	love.graphics.setCanvas(old)
	love.graphics.setShader(shader)
	love.graphics.setBlendMode(mode, alphamode)
	love.graphics.setColor(r,g,b,a)
end

passes = 8
bx = 4
by = 4
intensity = 1.0
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
	
	self.zoom.x = math.clamp(self.zoom.x, 0.01, math.huge)
	self.zoom.y = math.clamp(self.zoom.y, 0.01, math.huge)
	
	local w = (self.texture and self.texture.width  or graphics.getWidth()) * 0.5
	local h = (self.texture and self.texture.height or graphics.getHeight()) * 0.5
	
	self.bounds:Set(self.transform.globalPosition.x - w * self.zoom.x, self.transform.globalPosition.y - h * self.zoom.y, (w * self.zoom.x) * 2, (h * self.zoom.y) * 2)
	
	graphics.push()

	graphics.translate(w, h)
	graphics.rotate(-self.transform.globalRotation)
	graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
	graphics.translate(-self.transform.globalPosition.x, -self.transform.globalPosition.y)
	
	for k, v in pairs(self.canvases) do
		graphics.setCanvas(v.source)
		graphics.clear(0, 0, 0, 0)
	end

	graphics.setCanvas(self.canvases.colour.source, self.canvases.emission.source)

	DoRender(self, w, h)
	
	graphics.pop()
	
	graphics.setCanvas(self.canvases.post.source)
	graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)

	--Grid
	if self.cameraType == CameraType.SceneView then
		graphics.push()
		graphics.origin()

		self.transform.rotation = 0
		grid(self, w * 2, h * 2)

		graphics.pop()
	end

	graphics.setColor(255, 255, 255, 255)
	graphics.setShader()

	--diffuse
	graphics.setBlendMode("alpha")
	graphics.draw(Camera.main.canvases.colour.source, 0, 0, 0, 1, 1)

	--emission
	graphics.setBlendMode("screen")

	graphics.draw(Camera.main.canvases.emission.source, 0, 0, 0, 1, 1)

	graphics.setCanvas()

	graphics.setBlendMode("alpha")

	CallFunctionOnAll("OnRenderObject", self)
	CallFunctionOnAll("OnPostRender", self)
end

function Class:OnDrawGizmos(camera)
	if self ~= camera and camera.cameraType == CameraType.SceneView then
	--if camera.cameraType == CameraType.SceneView and self.cameraType == CameraType.Game then
		--local w = (self.texture and self.texture.width  or love.graphics.getWidth()) * 0.5
		--local h = (self.texture and self.texture.height or love.graphics.getHeight()) * 0.5
		
		--love.graphics.rectangle("line", self.transform.globalPosition.x - w, self.transform.globalPosition.y - h, w * 2, h * 2)
		graphics.rectangle("line", self.bounds.x, self.bounds.y, self.bounds.w, self.bounds.h)
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