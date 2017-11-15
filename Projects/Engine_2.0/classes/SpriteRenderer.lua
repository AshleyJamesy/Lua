local Class = class.NewClass("SpriteRenderer", "MonoBehaviour")

function Class:New()
	Class.Base.New(self)
	
	self:SerialiseField("sortingIndex",		0)
	self:SerialiseField("speed",			1.0)
	self:SerialiseField("animation_index",	1)
	self:SerialiseField("timer",			0.0)
	self:SerialiseField("animation",		"")
	self:SerialiseField("playing",			false)
	self:SerialiseField("filp",				Vector2(1, 1))
	self:SerialiseField("colour",			Colour(255,255,255,255))
end

function Class:Awake()
	
end

function Class:Update()
	
end

function Class:Render()
	love.graphics.setColor(self.colour:Unpack())
	love.graphics.rectangle("fill", 0, 0, 100, 100)
end