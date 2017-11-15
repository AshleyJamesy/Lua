local Class = class.NewClass("Matrix3")

function Class:New()
	self.values = { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
end

function Class:SetScale(sx, sy)
	self.values[1] = sx
	self.values[5] = sy
	self.values[9] = 1
end

function Class:SetRotation(r)
	local c = math.cos(r)
	local s = math.sin(r)

	self.values[1] = c
	self.values[2] = -s
	self.values[4] = s
	self.values[5] = c
	self.values[9] = 1
end

function Class:SetTranslation(x, y)
	self.values[3] = x
	self.values[6] = y
	self.values[9] = 1
end

function Class:GetScale()
	return self.values[1], self.values[5]
end

function Class:GetRotation()
	return math.atan(self.values[4] / self.values[5])
end

function Class:GetTranslation()
	return self.values[3], self.values[6]
end

function Class.__mul(a, b)
	local m = Matrix3()

	if TypeOf(a) == "number" then
		--float * Matrix3

		m.values[1] = b.values[1] * a
		m.values[2] = b.values[2] * a
		m.values[3] = b.values[3] * a
		m.values[4] = b.values[4] * a
		m.values[5] = b.values[5] * a
		m.values[6] = b.values[6] * a
		m.values[7] = b.values[7] * a
		m.values[8] = b.values[8] * a
		m.values[9] = b.values[9] * a
	end
	if TypeOf(b) == "number" then
		--Matrix3 * float

		m.values[1] = a.values[1] * b
		m.values[2] = a.values[2] * b
		m.values[3] = a.values[3] * b
		m.values[4] = a.values[4] * b
		m.values[5] = a.values[5] * b
		m.values[6] = a.values[6] * b
		m.values[7] = a.values[7] * b
		m.values[8] = a.values[8] * b
		m.values[9] = a.values[9] * b
	end

	--Matrix3 * Matrix3

	m.values[1] = a.values[1] * b.values[1] + a.values[2] * b.values[4] + a.values[3] * b.values[7]
	m.values[2] = a.values[1] * b.values[2] + a.values[2] * b.values[5] + a.values[3] * b.values[8]
	m.values[3] = a.values[1] * b.values[3] + a.values[2] * b.values[6] + a.values[3] * b.values[9]
	m.values[4] = a.values[4] * b.values[1] + a.values[5] * b.values[4] + a.values[6] * b.values[7]
	m.values[5] = a.values[4] * b.values[2] + a.values[5] * b.values[5] + a.values[6] * b.values[8]
	m.values[6] = a.values[4] * b.values[3] + a.values[5] * b.values[6] + a.values[6] * b.values[9]
	m.values[7] = a.values[7] * b.values[1] + a.values[8] * b.values[4] + a.values[9] * b.values[7]
	m.values[8] = a.values[7] * b.values[2] + a.values[8] * b.values[5] + a.values[9] * b.values[8]
	m.values[9] = a.values[7] * b.values[3] + a.values[8] * b.values[6] + a.values[9] * b.values[9]
	
	return m
end