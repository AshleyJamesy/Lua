function dump(o, i)
	local i 		= i or 0
	local output 	= ""

	if type(o) == "table" then
		output = "{\n"

		for k, v in pairs(o) do
			output = output .. string.rep("   ", i + 1) .. k .. ":" .. dump(v, i + 1)
		end

		output = output .. string.rep("   ", i) .. "}"
	else
		if type(o) == "string" then
			output = "\"" .. tostring(o) .. "\""
		else
			output = tostring(o)
		end
	end

	return output .. "\n"
end

function unpack_ext(t, n, s)
	local args = {}
	for i = s or 1, n do
		args[i] = t[i]
	end
	
	return unpack(args)
end