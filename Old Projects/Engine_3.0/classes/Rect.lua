local Class = class.NewClass("Rect")

function Class:New(x, y, w, h)
	if x and TypeOf(x) ~= "number" then
		self:SerialiseField("x", x.x)
		self:SerialiseField("y", x.y)
		self:SerialiseField("z", x.w)
		self:SerialiseField("w", x.h)
	end
	
	self:SerialiseField("x", x)
	self:SerialiseField("y", y)
	self:SerialiseField("z", z)
	self:SerialiseField("w", w)
end

function Class:Position()
	return Vector2(self.x, self.y)
end

function Class:Size()
	return Vector2(self.w, self.h)
end

function Class:ToString()
	return self.x .. ", " .. self.y .. ", " .. self.w .. ", " .. self.h
end