local Class = class.NewClass("Rect")
Class:SetReference(false)

function Class:New(x, y, w, h)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x
		self.y = x.y
		self.w = x.w
		self.h = x.h
	end

	self.x = x or 0
	self.y = y or 0
	self.w = w or 1
	self.h = h or 1
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