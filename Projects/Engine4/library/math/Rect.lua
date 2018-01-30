local Class = class.NewClass("Rect")

function Class:New(x, y, w, h)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x
		self.y = x.y
		self.w = x.w
		self.h = x.h
	end

	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
end

function Class:Set(x, y, w, h)
	self.x = x or self.x
	self.y = y or self.y
	self.w = w or self.w
	self.h = h or self.h
end

function Class:Position()
	return class.Quick("Vector2", { self.x, self.y })
end

function Class:Size()
	return class.Quick("Vector2", { self.w, self.h })
end

function Class.Intersect(a, b)
	if (a.x + a.w < b.x) then return false end
	if (a.x > b.x + b.w) then return false end
	if (a.y + a.h < b.y) then return false end
	if (a.y > b.y + b.h) then return false end

	return true
end

function Class:ToString()
	return self.x .. ", " .. self.y .. ", " .. self.w .. ", " .. self.h
end