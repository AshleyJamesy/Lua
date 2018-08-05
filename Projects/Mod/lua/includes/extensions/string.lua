function string.split(str, sep)
	if sep == nil then
		sep = "%s"
	end

	local output, i = {}, 1
	for find in string.gmatch(str, "([^" .. sep .. "]+)") do
		output[i] = find
		i = i + 1
	end

	return output
end

function string.find_greedy(str, cha)
    local j = nil
    for i = 1, #str do
        if str:sub(i, i) == cha then
            j = i
        end
    end
    
    return j
end