include("class")

local Class, BaseClass = class.NewClass("Animation")
Animation = Class

function Class:New(fps, loop, frames)
	self.fps 		= fps 		or 1.0
	self.loop 		= loop 		or false
	self.frames 	= frames 	or {}
end