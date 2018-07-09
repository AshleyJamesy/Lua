--create colour_01 buffer and colour_02 buffer
--render all objects to colour_02
--render all objects + refraction to colour_01
--(using discard in shader)

local graphics = love.graphics

local function grid(camera, w, h, unit)
	--[[
		TODO: Subdivisons
	]]
	local r,g,b,a = camera.backgroundColour:Unpack()
	graphics.setLineStyle("rough")
	graphics.setColor(a - 0.25, a - 0.25, a - 0.25, 0.25)

	local unit = unit or 200

	local ix = math.floor(w / unit)
	local iy = math.floor(h / unit)
	
	local cx = (0 * unit) - (camera.transform.globalPosition.x % unit)
	local cy = (0 * unit) - (camera.transform.globalPosition.y % unit) 

	for x = 0, ix do
	 graphics.setLineWidth(1.0)
	 
		cx = (x * unit) - (camera.transform.globalPosition.x % unit)
		graphics.line(cx, 0, cx, h)
		
		for y = 0, iy do
			cy = (y * unit) - (camera.transform.globalPosition.y % unit)
			graphics.line(0, cy, w, cy)
		end
	end

	graphics.setColor(255, 255, 255, 255)
	graphics.setLineWidth(1.0)
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
	self.backgroundColour 	= Colour(0.5, 0.5, 0.7, 1)
	self.cameraType 		= CameraType.SceneView
	self.cullingMask 		= {}
	self.zoom 				= Vector2(1, 1)
	
	self.clipping = Vector2(0.01, 1000.0)

	self.buffers = 
	{
		colour 			= RenderTarget(),
		emission 	= RenderTarget(),
		post 				= RenderTarget(),
		back 				= RenderTarget()
	}

	self.view = {
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 }
	}

	self.viewport 	= Rect(0, 0, 1.0, 1.0)
	self.projection = {
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 }
	}
	
	self.bounds = Rect(0,0,0,0)
end

local ignore_table 	= { "Camera" }

local function sort(a, b)
    return 
    (a.gameObject.layer ^ 17) * (a.sortingOrder ^ 17) * ((a.gameObject.transparent and 1 or 2) ^ 17) ==
    (b.gameObject.layer ^ 17) * (b.sortingOrder ^ 17) * ((b.gameObject.transparent and 1 or 2) ^ 17) 
    and (a.__id < b.__id)
end

local function DoRender(camera, w, h)
	graphics.setColor(1, 1, 1, 1)
	
 local bounds = camera.bounds
 
 local batch = camera.scene.__hash:Get(bounds.x, bounds.y, bounds.x + bounds.w, bounds.y + bounds.h, camera.scene.hashUnit)
 
 table.sort(batch, sort)
 
 for k, v in pairs(batch) do
     v:Render(camera)
 end
 
 SceneManager:GetActiveScene():CallFunctionOnAll("OnDrawGizmos", nil, camera)
 
	graphics.setColor(1, 1, 1, 1)
end

function Class:Render()	
	self.zoom.x = math.clamp(self.zoom.x, 0.01, math.huge)
	self.zoom.y = math.clamp(self.zoom.y, 0.01, math.huge)
	
	local w = Screen.width 	* 0.5
	local h = Screen.height * 0.5
	
	self.bounds:Set(self.transform.globalPosition.x - w * self.zoom.x, self.transform.globalPosition.y - h * self.zoom.y, (w * self.zoom.x) * 2, (h * self.zoom.y) * 2)
	
	graphics.push()

	graphics.translate(w, h)
 graphics.scale(1 / self.zoom.x, 1 / self.zoom.y)
 
 love.graphics.applyTransform(self.transform.__cTransform:inverse())
 
	for k, v in pairs(self.buffers) do
		if k ~= "back" then
		    graphics.setCanvas(v.source)
		    graphics.clear(0, 0, 0, 0)
		end
	end

	graphics.setCanvas(self.buffers.colour.source, self.buffers.back.source)
	
	DoRender(self, w, h)
	
	graphics.pop()
	
	graphics.setCanvas(self.buffers.post.source)

	--grid
	if self.cameraType == CameraType.SceneView then
		graphics.clear(0.25, 0.25, 0.25, 1.0)

		graphics.push()
		graphics.origin()

		self.transform.rotation = 0
		grid(self, w * 2, h * 2)

		graphics.pop()
	else
		graphics.clear(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b, self.backgroundColour.a)
	end
	
	graphics.setColor(1, 1, 1, 1)
	graphics.setShader()

	--MERGING!
	--diffuse
	graphics.setBlendMode("alpha")
	graphics.draw(self.buffers.colour.source, 0, 0, 0, 1, 1)
	
	--emission
	--graphics.setBlendMode("add")
	--graphics.draw(self.buffers.emission.source, 0, 0, 0, 1, 1)

	--blur(self.buffers.emission.source, bx, bx, passes, intensity)
 
	graphics.reset()
	
 local back = self.buffers.back.source
 self.buffers.back.source = self.buffers.colour.source
 self.buffers.colour.source = back
end

function Class:OnDrawGizmos(camera)
	if self ~= camera and camera.cameraType == CameraType.SceneView then
		graphics.rectangle("line", self.bounds.x, self.bounds.y, self.bounds.w, self.bounds.h)
	end
end

function Class:GetProjectionMatrix()
	local f, n = self.clipping.x, self.clipping.y

	self.projection[1][1] = 2.0 / (Screen.width - 0)
	self.projection[1][2] = 0.0
	self.projection[1][3] = 0.0
	self.projection[1][4] = 0.0

	self.projection[2][1] = 0.0
	self.projection[2][2] = 2.0 / (Screen.height - 0.0)
	self.projection[2][3] = 0.0
	self.projection[2][4] = 0.0

	self.projection[3][1] = 0.0
	self.projection[3][2] = 0.0
	self.projection[3][3] = 2.0 / (f - n)
	self.projection[3][4] = 0.0

	self.projection[4][1] = -(Screen.width + 0) / (Screen.width - 0)
	self.projection[4][2] = -(Screen.height + 0.0) / (Screen.height - 0.0)
	self.projection[4][3] = -(f + n) / (f - n)
	self.projection[4][4] = 1.0;

	return self.projection
end

function Class:GetViewMatrix()
	local view = self.view
	local x,y,z,w = 1,2,3,4
	local cos  = math.cos(self.transform.globalRotation)
	local sin  = math.sin(self.transform.globalRotation)

	view[x][x] = (1.0 / Camera.main.zoom.x) * cos
	view[x][y] = (1.0 / Camera.main.zoom.x) * -sin
	view[x][z] = 0.0
	view[x][w] = 0.0
	view[y][x] = (1.0 / Camera.main.zoom.y) * sin
	view[y][y] = (1.0 / Camera.main.zoom.y) * cos
	view[y][z] = 0.0
	view[y][w] = 0.0
	view[z][x] = 0.0
	view[z][y] = 0.0
	view[z][z] = 1.0
	view[z][w] = 0.0
	view[w][x] = -self.transform.globalPosition.x
	view[w][y] = -self.transform.globalPosition.y
	view[w][z] = 0.0
	view[w][w] = 1.0
	
	return view
end

function Class:ScreenToWorld(x, y)
	return (x * self.zoom.x + self.transform.globalPosition.x) - (Screen.width * 0.5 * self.zoom.x),
		(y * self.zoom.y + self.transform.globalPosition.y) - (Screen.height * 0.5 * self.zoom.y)
end

function Class:MousePosition()
	return self:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y)
end

function Class:WorldToScreen(x, y)

end