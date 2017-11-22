local Class = class.NewClass("ArrayType")


function Class:New(typename, ...)
	if class.GetClass(typename) then
		self.type 		= typename
		self.base 		= class.GetClass(typename)
		self.properties = {}
		self.count 		= 0

		local g = class.New(typename, ...)

		local j = 0
		for k, v in pairs(g) do
			self.properties[k] = {}
			j = j + 1
		end

		self.storage = {}
	else
		error(typename .. " does not exist")
	end
end

function Class:Insert(index, value)
	if value then
		if self.type == value.__typename or value.__typename == nil then
			for k, v in pairs(self.properties) do
				local n = rawget(value, k)
				if n then
					if index then
						table.insert(self.properties[k], index, n)
					else
						self.properties[k][self.count + 1] = n
					end
				end
			end

			self.count = self.count + 1
		end
	end
end

function Class:Push(value)
	self:Insert(1, value)
end

function Class:Remove(index)
	for k, v in pairs(self.properties) do
		table.remove(v, index)
		
		self.count = self.count - 1
	end
end

function Class:Get(index, t)
	local t = t or setmetatable({}, self.base)
	for k, v in pairs(self.properties) do
		t[k] = self.properties[k][index]
	end
	
	return t
end

function Class:Clear()
	for k, v in pairs(self.properties) do
		self.properties[k] = {}
	end
end