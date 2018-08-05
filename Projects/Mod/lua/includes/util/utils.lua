function dump(o, i)
	local i 		= i or -1
	local output 	= ""
	
	if type(o) == "table" then
		for k, v in pairs(o) do
			if type(v) == "table" then
				print(k,v)
				output = output .. string.rep("   ", i) .. "\"" .. tostring(k) .. "\":\n" .. dump(v, i + 1)
			else
				output = output .. string.rep("   ", i) .. "\"" .. tostring(k) .. "\":" .. dump(v, i + 1)
			end
		end
	else
		if type(o) == "string" then
			output = string.rep("   ", i) .. "\"" .. tostring(o) .. "\""
		else
			output = string.rep("   ", i) .. tostring(o)
		end
	end
	
	return output .. "\n"
end

function fast_assert(condition, ...)
	if not condition then
		if getn(arg) > 0 then
			assert(condition, call(format, arg))
		else
			assert(condition)
		end
	end
end

function unpack_ext(t, n)
	local args = {}
	for i = 1, n do
		args[i] = t[i]
	end

	return unpack(args)
end