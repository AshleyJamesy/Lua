local Class = class.NewClass("SpartialHash")

function MakeKeys(shift,x1,y1,x2,y2)
	local sx 	= math.shiftright(x1 or 0, shift)
	local sy 	= math.shiftright(y1 or 0, shift)
	local ex 	= math.shiftright(x2 or x1 or 0, shift)
	local ey 	= math.shiftright(y2 or y1 or 0, shift)
	local keys 	= {}
	
	--Buckets this rect takes up
	for i = sy, ey do
		for j = sx, ex do
			keys[#keys + 1] = { x = j, y = i }
		end
	end

	return keys
end

function Class:New()
	self.power 		= 6
	self.hash 		= {}
	self.list 		= {}
	self.lastCleard = 0
end

function Class:Clear()
	self.hash = {}
end

function Class:GetBucketCount()
	local i = 0
	for k, v in pairs(self.hash) do
		if #v > 0 then
			i = i + 1
		end
	end

	return i
end

function Class:GetOptimalPower()
	
end

function Class:Insert(object,x1,y1,x2,y2)
	local keys = MakeKeys(self.power,x1,y1,x2,y2)
	
	if table.HasValue(self.list, object) then
	else
		self.list[#self.list + 1] = object
	end
	
	for k, v in pairs(keys) do
		local bucket = tostring(v.x) .. ":" .. tostring(v.y)

		if self.hash[bucket] then
			self.hash[bucket][#self.hash[bucket] + 1] = object
		else
			self.hash[bucket] = { object }
		end
	end
end

function Class:Retrieve(x1,y1,x2,y2)
	local keys = MakeKeys(self.power,x1,y1,x2,y2)
	return table.Clone(keys)
end

function Class:Draw()
	love.graphics.setColor(255,255,255,80)

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local d = 2 ^ self.power

	for i = 0, math.ceil(w / d) do
		love.graphics.line(i * d, 0, i * d, h)
	end

	for i = 0, math.ceil(h / d) do
		love.graphics.line(0, i * d, w, i * d)
	end

	love.graphics.setColor(255,0,0,255)

	--[[
	for k, v in pairs(self.list) do
		local keys = MakeKeys(self.power, v:GetAABB())
		for k, v in pairs(keys) do
			love.graphics.rectangle("line", v.x * d, v.y * d, d, d)
		end
	end
	]]

	love.graphics.setColor(255,255,255,255)
end