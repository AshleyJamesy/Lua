local Class = class.NewClass("Rect")

function Class:New(x, y, w, h)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x
		self.y = x.y
		self.w = x.w
		self.h = x.h
	end
	
	self.x = x
	self.y = y
	self.w = w
	self.h = h
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