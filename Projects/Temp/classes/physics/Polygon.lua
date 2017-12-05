local Class = class.NewClass("Polygon")

local function magnitude(x,y)
	return math.abs(math.sqrt(x * x + y * y))
end

local function normalised(x,y)
	local m = magnitude(x,y)
	return math.abs(x) > 0 and x / m or 0, math.abs(y) > 0 and y / m or 0
end

local function perpendicular(x,y)
	return -y, x
end

local function cross(x1,y1,x2,y2)
	return x1 * y2 - y2 * x2
end

local function dot(x1,y1,x2,y2)
	return x1 * x2 + y1 * y2
end

local function project(axis_x, axis_y, points, x, y, s, r)
	local min = dot(axis_x, axis_y, (s or 1.0) * points[1] + (x or 0), (s or 1.0) * points[2] + (y or 0))
	local max = min

	for i = 2, #points * 0.5 do
		local index = (2 * i) - (2 - 1)

		local projection = dot(axis_x, axis_y, (s or 1.0) * points[index + 0] + (x or 0), (s or 1.0) * points[index + 1] + (y or 0))

		min = projection < min and projection or min
		max = projection > max and projection or max
	end

	return min, max
end

function Class:New(points)
	self.x 			= 0.0
	self.y 			= 0.0
	self.scale 		= 1.0
	self.rotation 	= 0.0
	self.group 		= 0
	self.points 	= table.Clone(points)
	self.normals 	= {}
	self.kinematic 	= false

	self.radius 	= 0.0

	self.aabb = Rect(math.huge,math.huge,-math.huge,-math.huge)

	for i = 1, #self.points * 0.5 do
		local index = (2 * i) - (2 - 1)

		local x1 	= self.points[index + 0]
		local y1 	= self.points[index + 1]
		local x2 	= self.points[index + 2] or self.points[1]
		local y2 	= self.points[index + 3] or self.points[2]

		local px, py = perpendicular(x1 - x2, y1 - y2)
		local nx, ny = normalised(px, py)

		self.normals[index + 0] = nx
		self.normals[index + 1] = ny

		self.aabb.x1 	= math.min(self.aabb.x1 or x1, x1)
		self.aabb.y1 	= math.min(self.aabb.y1 or y1, y1)
		self.aabb.x2 	= math.max(self.aabb.x2 or x1, x1)
		self.aabb.y2 	= math.max(self.aabb.y2 or y1, y1)

		local m = magnitude(x1, y1)
		self.radius = m > self.radius and m or self.radius
	end
end

function Class:Clockwise()
	local sum = 0
	for i = 1, #self.points * 0.5 do
		local index 	= (2 * i) - (2 - 1)

		sum = sum + 
		((self.points[index + 2] or self.points[1]) - self.points[index + 0]) * 
		((self.points[index + 3] or self.points[2]) + self.points[index + 1])
	end
	
	return sum > 0
end

--Returns table containing resulting polygons after slice
function Class:Slice(x1,y1,x2,y2)

end

function Class:Intersects(x1,y1,x2,y2)
	
end

function Class:GetAABB()
	local tx1 = self.x + (self.aabb.x1 * self.scale)
	local ty1 = self.y + (self.aabb.y1 * self.scale)
	local tx2 = self.x + (self.aabb.x2 * self.scale)
	local ty2 = self.y + (self.aabb.y2 * self.scale)

	return tx1, ty1, tx2, ty2
end

function Class:Draw(debug)
	local t = {}
	for i = 1, #self.points * 0.5 do
		local index 	= (2 * i) - (2 - 1)
		t[index + 0] 	= self.scale * self.points[index + 0] + self.x
		t[index + 1] 	= self.scale * self.points[index + 1] + self.y
	end

	if self.group == 1 then
		love.graphics.setColor(255,0,0,255)
	elseif self.group == 2 then
		love.graphics.setColor(0,255,0,255)
	elseif self.group == 3 then
		love.graphics.setColor(0,0,255,255)
	else
		love.graphics.setColor(255,255,255,255)
	end

	love.graphics.polygon("line", t)

	if debug then
		for i = 1, #self.normals * 0.5 do
			local index = (2 * i) - (2 - 1)
			local x 	= self.scale * self.normals[index + 0]
			local y 	= self.scale * self.normals[index + 1]

			love.graphics.line(self.x, self.y, x * 0.5 + self.x, y * 0.5 + self.y)
		end

		love.graphics.setColor(255,255,255,255)
	end
end

function Class.Overlapping(a, b)
	local normalsA, normalsB
	local overlap, mx, my = math.huge, math.huge, math.huge

	if magnitude(a.x - b.x, a.y - b.y) > (a.radius * a.scale + b.radius * b.scale) then
		return false, 0, 0
	end

	--Optimised
	if #a.normals == #b.normals then
		normalsA = a.normals
		normalsB = b.normals

		for i = 1, #normalsA * 0.5 do
			local index = (2 * i) - (2 - 1)

			local minA, maxA = project(a.normals[index + 0], a.normals[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
			local minB, maxB = project(a.normals[index + 0], a.normals[index + 1], b.points, b.x, b.y, b.scale, b.rotation)

			if minB > maxA or maxB < minA then  
				return false, 0, 0
			else
				local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
				if math.abs(overlap) < magnitude(mx, my) then
					mx = a.normals[index + 0] * overlap;
					my = a.normals[index + 1] * overlap;
				end
			end

			minA, maxA = project(b.normals[index + 0], b.normals[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
			minB, maxB = project(b.normals[index + 0], b.normals[index + 1], b.points, b.x, b.y, b.scale, b.rotation)
			
			if minB > maxA or maxB < minA then  
				return false, 0, 0
			else
				local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
				if math.abs(overlap) < magnitude(mx, my) then
					mx = b.normals[index + 0] * overlap;
					my = b.normals[index + 1] * overlap;
				end
			end
		end
	else
		if #a.normals > #b.normals then
			normalsA = a.normals
			normalsB = b.normals
		else
			normalsA = b.normals
			normalsB = a.normals
		end

		for i = 1, #normalsA * 0.5 do
			local index = (2 * i) - (2 - 1)

			local minA, maxA = project(normalsA[index + 0], normalsA[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
			local minB, maxB = project(normalsA[index + 0], normalsA[index + 1], b.points, b.x, b.y, b.scale, b.rotation)

			if minB > maxA or maxB < minA then  
				return false, 0, 0
			else
				local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
				if math.abs(overlap) < magnitude(mx, my) then
					mx = normalsA[index + 0] * overlap;
					my = normalsA[index + 1] * overlap;
				end
			end

			if i < #normalsB * 0.5 then
				minA, maxA = project(normalsB[index + 0], normalsB[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
				minB, maxB = project(normalsB[index + 0], normalsB[index + 1], b.points, b.x, b.y, b.scale, b.rotation)
				
				if minB > maxA or maxB < minA then  
					return false, 0, 0
				else
					local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
					if math.abs(overlap) < magnitude(mx, my) then
						mx = normalsB[index + 0] * overlap;
						my = normalsB[index + 1] * overlap;
					end
				end
			end
		end
	end

	--UnOptimised
	--[[
	for i = 1, #a.normals * 0.5 do
		local index = (2 * i) - (2 - 1)

		local minA, maxA = project(a.normals[index + 0], a.normals[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
		local minB, maxB = project(a.normals[index + 0], a.normals[index + 1], b.points, b.x, b.y, b.scale, b.rotation)

		if minB > maxA or maxB < minA then  
			return false, 0, 0
		else
			local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
			if math.abs(overlap) < magnitude(mx, my) then
				mx = a.normals[index + 0] * overlap;
				my = a.normals[index + 1] * overlap;
			end
		end
	end

	for i = 1, #b.normals * 0.5 do
		local index = (2 * i) - (2 - 1)

		local minA, maxA = project(b.normals[index + 0], b.normals[index + 1], a.points, a.x, a.y, a.scale, a.rotation)
		local minB, maxB = project(b.normals[index + 0], b.normals[index + 1], b.points, b.x, b.y, b.scale, b.rotation)

		if minB > maxA or maxB < minA then
			return false, 0, 0
		else
			local overlap = maxA >= maxB and -(maxB - minA) or (maxA - minB)
			if math.abs(overlap) < magnitude(mx, my) then
				mx = b.normals[index + 0] * overlap;
				my = b.normals[index + 1] * overlap;
			end
		end
	end
	]]

	return true, mx, my
end

