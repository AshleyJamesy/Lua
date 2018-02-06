function string.split(input, sep)
	if sep == nil then
		sep = "%s"
	end

	local output, i = {}, 1
	for find in string.gmatch(input, "([^" .. sep .. "]+)") do
		output[i] = find
		i = i + 1
	end

	return output
end