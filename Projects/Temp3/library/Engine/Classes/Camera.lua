local Class = class.NewClass("Camera", "Behaviour")

CameraType = enum{
	"Game", 		--Used to indicate a regular in-game camera.
	"SceneView", 	--Used to indicate that a camera is used for rendering the Scene View in the Editor.
	"Preview" 		--Used to indicate a camera that is used for rendering previews in the Editor.
}

function Class:New()
	Class:Base().New(self)

	self.scene 				= nil
	self.backgroundColour 	= Colour(73, 73, 73, 255)
	self.cameraType 		= CameraType.None
	self.cullingMask 		= {}
	self.zoom 				= Vector2(1,1)
	self.texture 			= nil
end

--Static Methods


--Public Methods
function Class:Render()
	
end

function Class:ScreenToWorld(x, y)

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