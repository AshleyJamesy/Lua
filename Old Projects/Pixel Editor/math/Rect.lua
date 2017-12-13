include("class")
include("math/Vector2")

local Class, BaseClass = class.NewClass("Rect")
Rect = Class

function Class:New(x,y,w,h)
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

function Class:SetPosition(x, y)
	if x and TypeOf(x) ~= "number" then
		self.x = x.x
		self.y = x.y
	end

	self.x = x or 0
	self.y = y or 0
end

function Class:SetSize(w, h)
	if x and TypeOf(x) ~= "number" then
		self.w = x.x
		self.h = x.y
	end

	self.w = w or 0
	self.h = h or 0
end

function Class:Contains(x, y)
	if x and TypeOf(x) ~= "number" then
		return x.x > self.x and x.x < self.x + self.w and x.y > self.y and x.y < self.y + self.h
	end

	return x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h
end