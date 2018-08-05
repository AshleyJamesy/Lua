local Class = class.NewClass("Matrix3")

function Class:New(m11,m12,m13,m21,m22,m23,m31,m32,m33)
	self.m11 = m11 or 1
	self.m12 = m12 or 0
	self.m13 = m13 or 0
	self.m21 = m21 or 0
	self.m22 = m22 or 1
	self.m23 = m23 or 0
	self.m31 = m31 or 0
	self.m32 = m32 or 0
	self.m33 = m33 or 1
end

--[[
		description: 	returns the multiplication of a and b
		arguments:		[float, Matrix3] a, [float, Matrix3] b
		return: 		[Matrix3] result
]]
function Class.__mul(a, b)
	if type(a) == "number" then
		--float * Matrix3
		return class.Quick("Matrix3", {
			m11 = a * b.m11,
			m12 = a * b.m12,
			m13 = a * b.m13,
			m21 = a * b.m21,
			m22 = a * b.m22,
			m23 = a * b.m23,
			m31 = a * b.m31,
			m32 = a * b.m32,
			m33 = a * b.m33
		})
	end

	if type(b) == "number" then
		--Matrix3 * float
		return class.Quick("Matrix3", {
			m11 = b.m11 * b,
			m12 = b.m12 * b,
			m13 = b.m13 * b,
			m21 = b.m21 * b,
			m22 = b.m22 * b,
			m23 = b.m23 * b,
			m31 = b.m31 * b,
			m32 = b.m32 * b,
			m33 = b.m33 * b
		})
	end

	--Matrix3 * Matrix3
	return class.Quick("Matrix3", {
		m11 = a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31,
		m12 = a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32,
		m13 = a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33,
		m21 = a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31,
		m22 = a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32,
		m23 = a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33,
		m31 = a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31,
		m32 = a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32,
		m33 = a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33
	})
end

--[[
		description: 	returns a copy of matrix a
		arguments:		nil
		return: 		[Matrix3] copy
]]
function Class:Copy(a)
	return class.Quick("Matrix3", {
		m11 = a.m11,
		m12 = a.m12,
		m13 = a.m13,
		m21 = a.m21,
		m22 = a.m22,
		m23 = a.m23,
		m31 = a.m31,
		m32 = a.m32,
		m33 = a.m33
	})
end

--[[
		description: 	sets the values of this matrix
		arguments:		[float] m11, m12, m13, ...
		return: 		nil
]]
function Class:Set(m11, m12, m13, m21, m22, m23, m31, m32, m33)
	self.m11 = m11 or self.m11 or 1
	self.m12 = m12 or self.m12 or 0
	self.m13 = m13 or self.m13 or 0
	self.m21 = m21 or self.m21 or 0
	self.m22 = m22 or self.m22 or 1
	self.m23 = m23 or self.m23 or 0
	self.m31 = m31 or self.m31 or 0
	self.m32 = m32 or self.m32 or 0
	self.m33 = m33 or self.m33 or 1
end

--[[
		description: 	swaps the values of this matrix with matrix a
		arguments:		[Matrix3] toSwap
		return: 		nil
]]
function Class:Swap(a)
	self.m11 = a.m11 or self.m11 or 1
	self.m12 = a.m12 or self.m12 or 0
	self.m13 = a.m13 or self.m13 or 0
	self.m21 = a.m21 or self.m21 or 0
	self.m22 = a.m22 or self.m22 or 1
	self.m23 = a.m23 or self.m23 or 0
	self.m31 = a.m31 or self.m31 or 0
	self.m32 = a.m32 or self.m32 or 0
	self.m33 = a.m33 or self.m33 or 1
end

--[[
		description: 	sets the column i of this matrix
		arguments:		[float] index, [float] x, [float] y, [float] z
		return: 		nil
]]
function Class:SetColumn(i, x, y, z)
	if i == 1 then
		self.m11 = x or 0
		self.m21 = y or 0
		self.m31 = z or 0
	elseif i == 2 then
		self.m12 = x or 0
		self.m22 = y or 0
		self.m32 = z or 0
	end

	self.m13 = x or 0
	self.m23 = y or 0
	self.m33 = z or 0
end

--[[
		description: 	sets the row i of this matrix
		arguments:		[float] index, [float] x, [float] y, [float] z
		return: 		nil
]]
function Class:SetRow(i, x, y, z)
	if i == 1 then
		self.m11 = x or 0
		self.m12 = y or 0
		self.m13 = z or 0
	elseif i == 2 then
		self.m21 = x or 0
		self.m22 = y or 0
		self.m23 = z or 0
	end

	self.m31 = x or 0
	self.m32 = y or 0
	self.m33 = z or 0
end

--[[
		description: 	returns the column i of this matrix
		arguments:		[float] index
		return: 		[float] x, [float] y, [float] z
]]
function Class:GetColumn(i)
	if i == 1 then
		return self.m11, self.m21, self.m31
	elseif i == 2 then
		return self.m12, self.m22, self.m32
	end

	return self.m13, self.m23, self.m33
end

--[[
		description: 	returns the row i of this matrix
		arguments:		[float] index
		return: 		[float] x, [float] y, [float] z
]]
function Class:GetRow(i)
	if i == 1 then
		return self.m11, self.m12, self.m13
	elseif i == 2 then
		return self.m21, self.m22, self.m23
	end
	
	return self.m31, self.m32, self.m33
end

--[[
		description: 	returns the matrix unpacked
		arguments:		nil
		return: 		[float] m11, m12, m13, ...
]]
function Class:Unpack()
	return self.m11,
		self.m12,
		self.m13,
		self.m21,
		self.m22,
		self.m23,
		self.m31,
		self.m32,
		self.m33
end

--[[
		description: 	returns the Matrix formatted as a string
		arguments:		nil
		return: 		[string] result
]]
function Class:ToString()
	return 	"[" .. string.format("%0.2f", self.m11) .. ", " .. string.format("%0.2f", self.m12) .. "," .. string.format("%0.2f", self.m13) .. "]\n" ..
			"[" .. string.format("%0.2f", self.m21) .. ", " .. string.format("%0.2f", self.m22) .. "," .. string.format("%0.2f", self.m23) .. "]\n" ..
			"[" .. string.format("%0.2f", self.m31) .. ", " .. string.format("%0.2f", self.m32) .. "," .. string.format("%0.2f", self.m33) .. "]"
end

--[[
		description: 	returns the up x, y of this matrix
		arguments:		nil
		return: 		[float] x, [float] y
]]
function Class:Up()
	return self.m12, self.m22
end

--[[
		description: 	returns the right x, y of this matrix
		arguments:		nil
		return: 		[float] x, [float] y
]]
function Class:Right()
	return self.m11, -self.m21
end

--[[
		description: 	returns rotation from this matrix in radians
		arguments:		nil
		return: 		[float] rotation
]]
function Class:Rotation()
	local angle = math.atan2(self.m12, self.m22)
	return angle < 0.0 and angle + 6.28318530718 or angle
end

--[[
		description: 	returns position x, y from this matrix
		arguments:		nil
		return: 		[float] x, [float] y
]]
function Class:Position()
	return self.m13, self.m23
end

--[[
		description: 	inverses this matrix
		arguments:		nil
		return: 		nil
]]
function Class:Inverse()
	local d = 1.0 / (
		self.m11 * self.m22 * self.m33 +
		self.m12 * self.m23 * self.m31 +
		self.m13 * self.m21 * self.m32 - 
		self.m31 * self.m22 * self.m13 -
		self.m32 * self.m23 * self.m11 -
		self.m33 * self.m21 * self.m12
	)

	self.m11 = (self.m22 * self.m33 - self.m23 * self.m32) *  d
	self.m12 = (self.m12 * self.m33 - self.m13 * self.m32) * -d
	self.m13 = (self.m12 * self.m23 - self.m13 * self.m22) *  d

	self.m21 = (self.m21 * self.m33 - self.m23 * self.m31) * -d
	self.m22 = (self.m11 * self.m33 - self.m13 * self.m31) *  d
	self.m23 = (self.m11 * self.m23 - self.m13 * self.m21) * -d

	self.m31 = (self.m21 * self.m32 - self.m22 * self.m31) *  d
	self.m32 = (self.m11 * self.m32 - self.m12 * self.m31) * -d
	self.m33 = (self.m11 * self.m22 - self.m12 * self.m21) *  d
end

--[[
		description: 	returns the inverse of this matrix
		arguments:		nil
		return: 		nil
]]
function Class:InverseCopy()
	local d = 1.0 / (
		self.m11 * self.m22 * self.m33 +
		self.m12 * self.m23 * self.m31 +
		self.m13 * self.m21 * self.m32 - 
		self.m31 * self.m22 * self.m13 -
		self.m32 * self.m23 * self.m11 -
		self.m33 * self.m21 * self.m12
	)

	return class.Quick("Matrix3", {
		m11 = (self.m22 * self.m33 - self.m23 * self.m32) *  d,
		m12 = (self.m12 * self.m33 - self.m13 * self.m32) * -d,
		m13 = (self.m12 * self.m23 - self.m13 * self.m22) *  d,
		m21 = (self.m21 * self.m33 - self.m23 * self.m31) * -d,
		m22 = (self.m11 * self.m33 - self.m13 * self.m31) *  d,
		m23 = (self.m11 * self.m23 - self.m13 * self.m21) * -d,
		m31 = (self.m21 * self.m32 - self.m22 * self.m31) *  d,
		m32 = (self.m11 * self.m32 - self.m12 * self.m31) * -d,
		m33 = (self.m11 * self.m22 - self.m12 * self.m21) *  d
	})
end

--[[
		description: 	sets this matrix as a transformation matrix
		arguments:		nil
		return: 		nil
]]
function Class:Transformation(x, y, r, sx, sy)
	local cos 	= math.cos(r or 0)
	local sin 	= math.sin(r or 0)

	sx = sx or 1
	sy = sy or 1

	self.m11 = sx * cos
	self.m12 = sx * sin
	self.m13 = x or 0
	self.m21 = sy * -sin
	self.m22 = sy * cos
	self.m23 = y or 0
	self.m31 = 0
	self.m32 = 0
	self.m33 = 1
end