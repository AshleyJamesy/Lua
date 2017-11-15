function table.Count(t)
	local i = 0
	for k in pairs(t) do 
		i = i + 1 
	end
	
	return i
end

function table.Merge(src, dst)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			table.Merge(dst[k], v)
		else
			dst[k] = v
		end
	end

	return dst
end

function table.Copy(src, lookup_table)
	local t = {}
	setmetatable(t, getmetatable(t))

	for k, v in pairs(src) do
		if type(v) ~= "table" then
			t[k] = v
		else
			lookup_table		= lookup_table or {}
			lookup_table[src]	= t

			if lookup_table[v] then
				t[k] = lookup_table[v]
			else
				t[k] = tcopy(v,lookup_table)
			end
		end
	end

	return t
end

function table.ShallowCopy(t)
	local _type = type(t)
	local _copy

	if _type == 'table' then
		_copy = {}
		for key, value in pairs(t) do
			copy[key] = value
		end
	else
		_copy = t
	end

	return _copy
end

function table.Clone(t)
	return { unpack(t) }
end

function table.HasValue(t, value)
	for k, v in pairs(t) do
		if v == value then 
			return true, k
		end
	end
	
	return false, nil
end

--[[
	need to declared __eq for keys that don't require table as a reference
	example;
		t[Coordinate(1,0)] = "This is 1,0"
		
		--This will return false if __eq method has not been declared
		table.HasKey(t, Coordinate(1,0))
]]
function table.HasKey(t, key)
	for k, v in pairs(t) do
		if k == key then 
			return true, k
		end
	end
	
	return false, nil
end

function table.Add(dst, src)
	if type(src) ~= "table" then return dst end
	if type(dst) ~= "table" then dst = {}	end

	for k, v in pairs(src) do
		table.insert(dst, v)
	end

	return src
end

function table.SortByKey(t, desc)
	local sorted = {}

	for k, _ in pairs(t) do 
		table.insert(sorted, k) 
	end

	if desc then
		table.sort(sorted, function(a, b) return t[a] < t[b] end)
	else
		table.sort(sorted, function(a, b) return t[a] > t[b] end)
	end

	return sorted
end

function table.IsSequential(t)
	local i = 1
	for key, value in pairs(t) do
		if t[i] == nil then 
			return false 
		end
		
		i = i + 1
	end

	return true
end

function table.GetKeys(t)
	local keys 	= {}
	local i 	= 1
	for k, v in pairs(t) do
		keys[i] = k
		i = i + 1
	end

	return keys
end

function table.GetComponent(t, index, stride, offset)
	local j = {}

	for i = 1, stride do
		c[i] = t[stride * (index + (offset or 0)) - (stride - 1) + (i - 1)]
	end

	return j
end