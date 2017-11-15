local Class = class.NewClass("Colour", "Object")

function Class:New(r, g, b, a)
	if r and TypeOf(r) ~= "number" then
		self:SerialiseField("r", r.r or 0)
		self:SerialiseField("g", r.g or 0)
		self:SerialiseField("b", r.b or 0)
		self:SerialiseField("a", r.a or 255)
		return
	end
	
	self:SerialiseField("r", r and math.clamp(r,0,255) or 0)
	self:SerialiseField("g", g and math.clamp(g,0,255) or self.r or 0)
	self:SerialiseField("b", b and math.clamp(b,0,255) or self.r or 0)
	self:SerialiseField("a", a and math.clamp(a,0,255) or 255)
end

function Class:SetRed(value)
	self.r = math.clamp(value,0,255)
end

function Class:SetGreen(value)
	self.g = math.clamp(value,0,255)
end

function Class:SetBlue(value)
	self.b = math.clamp(value,0,255)
end

function Class:SetAlpha(value)
	self.a = math.clamp(value,0,255)
end

function Class.Lerp(a, b, t)
	return a + (b - a) * t
end

function Class.__add(a,b)
	--Colour + Colour
	local nr = (a.r or 0) + (b.r or 0)
	local ng = (a.g or 0) + (b.g or 0)
	local nb = (a.b or 0) + (b.b or 0)
	local na = (a.a or 0) + (b.a or 0)
	return Colour(nr,ng,nb,na)
end

function Class.__sub(a,b)
	--Colour - Colour
	local nr = (a.r or 0) + (b.r or 0)
	local ng = (a.g or 0) + (b.g or 0)
	local nb = (a.b or 0) + (b.b or 0)
	local na = (a.a or 0) + (b.a or 0)

	return Colour(nr,ng,nb,na)
end

function Class.__mul(a,b)
	--float * Colour
	if TypeOf(a) == "number" then
		return Colour(b.r * a, b.g * a, b.b * a, b.a * a)
	end

	--Colour * float
	if TypeOf(b) == "number" then
		return Colour(a.r * b, a.g * b, a.b * b, a.a * b)
	end
end

function Class:Set(r,g,b,a)
	self:New(r,g,b,a)
end

function Class:ToString()
	return self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. self.a
end

function Class:Unpack()
	return self.r, self.g, self.b, self.a
end