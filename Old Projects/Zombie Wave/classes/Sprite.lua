local Class = class.NewClass("Sprite", "Asset")
Class.Extenstion = "sprite"

function Class:NewAsset(path)
	self.image 	= Image(path)
	self.frames = {}
	self.pivot 	= Vector2(0,0)
end

function Class:LoadAsset(asset)
	self.image 	= Image(asset.path)
	self.frames = asset.frames
	self.pivot 	= Vector2(asset.pivot.x, asset.pivot.y)
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

function Class:SaveAsset(asset)
	asset.frames = self.frames
	asset.pivot = {
		x = self.pivot.x,
		y = self.pivot.y
	}
end