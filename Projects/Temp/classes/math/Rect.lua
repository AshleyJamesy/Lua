local Class = class.NewClass("Rect")

function Class:New(x, y, w, h)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x or 0
		self.y = x.y or 0
		self.w = x.w or 0
		self.h = x.h or 0
		return
	end
	
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
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