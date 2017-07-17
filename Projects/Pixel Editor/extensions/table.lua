include("types")

function table.merge(src, dst)
	--check both are tables
	if not types.IsTable(src) or not types.IsTable(dst) then 
		return error("table not table")
	end

	for k, v in pairs(src) do
		if TypeOf(v) == TypeOf(dst[k]) then
			table.merge(dst[k], v)
		else
			dst[k] = v
		end
	end
	
	return dst
end

function table.copy(src, dst, overwrite)
	--check both are tables
	if(not IsTable(src) or not IsTable(dst)) then 
		return error("table not table")
	end

	for k, v in pairs(src) do
		if(dst[k] == nil) then
			dst[k] = v
		else
			if overwrite == true then
				print(k, v)
				dst[k] = v
			end
		end
	end

	return dst
end

function table.hasValue(t, value)
	for k, v in pairs(t) do
		if v == value then return true end
	end
	
	return false
end

function table.hasKey(t, key)
	for k, v in pairs(t) do
		if k == key then return true end
	end
	
	return false
end

function table.isSequenced(t)
    local p = 1
    for k, v in pairs(t) do
        if type(k) ~= "number" then
            return false
        end
        
        if k - p ~= 1 then
            return false
        end
        
        p = k
    end
    
    return true
end