local Class = class.NewClass("Colour", "Object")

function Class:New(r, g, b, a)
	if r and TypeOf(r) ~= "number" then
		self.r = r.r or 0
		self.g = r.g or 0
		self.b = r.b or 0
		self.a = r.a or 255
		return
	end

	self.r = r and math.clamp(r,0,255) or 0
	self.g = g and math.clamp(g,0,255) or self.r or 0
	self.b = b and math.clamp(b,0,255) or self.r or 0
	self.a = a and math.clamp(a,0,255) or 255
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
    return class.Quick("Colour", {
	       r = math.clamp(a.r + (b.r - a.r) * t, 0, 255),
	       g = math.clamp(a.g + (b.g - a.g) * t, 0, 255),
	       b = math.clamp(a.b + (b.b - a.b) * t, 0, 255),
	       r = math.clamp(a.a + (b.a - a.a) * t, 0, 255)
    })
end

function Class.__add(a,b)
	--Colour + Colour
	return class.Quick("Colour", {
	    r = math.clamp((a.r or 0) + (b.r or 0), 0, 255),
	    g = math.clamp((a.g or 0) + (b.g or 0), 0, 255),
	    b = math.clamp((a.b or 0) + (b.b or 0), 0, 255),
	    r = math.clamp((a.a or 0) + (b.a or 0), 0, 255)
	})
end

function Class.__sub(a,b)
	--Colour - Colour
	return class.Quick("Colour", {
	    r = math.clamp((a.r or 0) - (b.r or 0), 0, 255),
	    g = math.clamp((a.g or 0) - (b.g or 0), 0, 255),
	    b = math.clamp((a.b or 0) - (b.b or 0), 0, 255),
	    r = math.clamp((a.a or 0) - (b.a or 0), 0, 255)
	})
end

function Class.__mul(a,b)
	--float * Colour
	if TypeOf(a) == "number" then
	    return class.Quick("Colour", {
	        r = math.clamp(b.r * a, 0, 255),
	        g = math.clamp(b.g * a, 0, 255),
	        b = math.clamp(b.b * a, 0, 255),
	        r = math.clamp(b.a * a, 0, 255)
	    })
	end

	--Colour * float
	if TypeOf(b) == "number" then
	    return class.Quick("Colour", {
	        r = math.clamp(a.r * b, 0, 255),
	        g = math.clamp(a.g * b, 0, 255),
	        b = math.clamp(a.b * b, 0, 255),
	        r = math.clamp(a.a * b, 0, 255)
	   })
    end
end

function Class:Set(r,g,b,a)
    self:New(r,g,b,a)
end

function Class:Use()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
end

function Class:Reset()
    love.graphics.setColor(255, 255, 255, 255)
end

function Class:ToString()
	return self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. self.a
end

function Class:Unpack()
    return self.r, self.g, self.b, self.a
end