function TypeOf(src)
	if type(src) ~= "table" then
		return type(src)
	end

	if(src.__type == nil) then
		return type(src)
	end
	
	return src.__type[#src.__type]
end

function IsType(src, name)
 if type(src) ~= "table" then
		return type(src) == name
	end
	
	if(src.__type == nil) then
		return type(src) == name
	end
	
	for k, v in pairs(src.__type) do
	 if v == name then
	     return true
	 end
	end
	
	return false
end

function IsNil(src)
	return TypeOf(src) == "nil"
end

function IsFunction(src)
	return TypeOf(src) == "function"
end

function IsTable(src)
	return IsType(src, "table")
end

function IsBool(src)
	return TypeOf(src) == "boolean"
end

function IsString(src)
	return TypeOf(src) == "string"
end

function IsNumber(src)
	return TypeOf(src) == "number"
end