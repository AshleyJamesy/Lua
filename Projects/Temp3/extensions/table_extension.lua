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

function table.Copy(src)
	if type(src) == "table" then
		local t = {}
		setmetatable(t, getmetatable(src))

		for k, v in pairs(src) do
			t[k] = table.Copy(src[k])
		end
		
		return t
	end
	
	return src
end

function table.ShallowCopy(src)
	if type(t) == 'table' then
		local t = {}
		setmetatable(t, getmetatable(src))
		
		for k, v in pairs(src) do
			t[k] = src[k]
		end
		
		return t
	end
	
	return src
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
		j[i] = t[stride * (index + (offset or 0)) - (stride - 1) + (i - 1)]
	end

	return j
end

--[[
local meta_readOnly = {}
meta_readOnly.__newindex = function()
end

function readOnly(t)
	return setmetatable(t, meta_readOnly)
end
]]
