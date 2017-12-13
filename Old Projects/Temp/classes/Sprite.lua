local Class = class.NewClass("Sprite")

function Class:New(image)
	self.attributes = { 
		diffuse = image
	}
	
	self.frames = {}
	self.pivots = {}
end

function Class:AddFrame(x, y, w, h)
	local frame = {}
	frame.name = "frame"
	frame.x = x
	frame.y = y
	frame.w = w
	frame.h = h
	
	table.insert(self.frames, frame)
end

function Class:GetFrame(index)
	return self.frames[index]
end