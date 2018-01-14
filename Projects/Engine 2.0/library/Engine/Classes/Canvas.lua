local Class = class.NewClass("Canvas")

Canvas_RenderMode = enum{
	"ScreenSpace",
	"ScreenSpaceCamera",
	"WorldSpace"
}

function Class:New()
	self.renderMode = Canvas_RenderMode.ScreenSpace
end