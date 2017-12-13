include("extensions/table")
include("types")

module("serialise", package.seeall)

local function findNext(string, fchar, start, ignore)
	local i = start
	while(i < #string + 1) do
        local char = string.byte(string:sub(i, i))

        if(char == string.byte(fchar)) then
			return true, i
		else
			for j = 1, #ignore do 
				if(char == string.byte(ignore[j])) then
					i = i + 1
					break
				end
				
				if(j == #ignore) then return false, i end
			end
		end
    end
end

local function findUntil(string, fchar, start)
	local i = start
	while(i < #string + 1) do
        local char = string.byte(string:sub(i, i))
		
		if(char == string.byte(fchar)) then
			return true, i
		end
		
		i = i + 1
	end
	
	return false, i
end

local function findAny(string, start, ignore)
	local i = start
	local found = false
	while(i < #string + 1) do
		local char = string.byte(string:sub(i, i))
		
		for j = 1, #ignore do 
			if(char == string.byte(ignore[j])) then
				i = i + 1
				break
			end
			
			if(j == #ignore) then
				return true, i
			end
		end
	end
end

local SerialiseArray = function(name, tbl, indent) end

local function SerialiseObject(name, tbl, indent)
	local ind = string.rep("	", indent)
	local s = ind .. (name and "\"" .. name .. "\":{\n" or "{\n")

	local c = table.Count(tbl)
	local i = 1
	for key, value in pairs(tbl) do
		local t = type(value)
		if t == "table" then
			if table.IsSequential(value) then
				s = s .. string.format("%s%s", ind, SerialiseArray(key, value, indent + 1))
			else
				s = s .. string.format("%s%s", ind, SerialiseObject(key, value, indent + 1))
			end
		elseif t == "number" then
			s = s .. string.format("%s\"%s\":%d", ind .. "	", key, value)
		elseif t == "string" then
			s = s .. string.format("%s\"%s\":\"%s\"", ind .. "	", key, value)
		elseif t == "boolean" then
			s = s .. string.format("%s\"%s\":%s", ind .. "	", key, value and "true" or "false")
		elseif t == "nil" then
			s = s .. string.format("%s\"%s\":nil", ind .. "	", key)
		end

		if i < c then
			s = s .. ",\n"
		end

		i = i + 1
	end

	return s .. "\n" .. ind .. "}"
end

local function SerialiseArray(name, tbl, indent)
	local ind = string.rep("	", indent)
	local s = ind .. (name and "\"" .. name .. "\":[\n" or "[\n")

	local c = table.Count(tbl)
	local i = 1
	for key, value in pairs(tbl) do
		local t = type(value)
		if t == "table" then
			if table.IsSequential(value) then
				s = s .. string.format("%s%s", ind, SerialiseArray(key, value, indent + 1))
			else
				s = s .. string.format("%s%s", ind, SerialiseObject(key, value, indent + 1))
			end
		elseif t == "number" then
			s = s .. string.format("%s%d", ind .. "	", value)
		elseif t == "string" then
			s = s .. string.format("%s\"%s\"", ind .. "	", value)
		elseif t == "boolean" then
			s = s .. string.format("%s%s", ind .. "	", value and "true" or "false")
		elseif t == "nil" then
			s = s .. string.format("%s:nil", ind .. "	")
		end

		if i < c then
			s = s .. ",\n"
		end

		i = i + 1
	end

	return s .. "\n" .. ind .. "]"
end

function Serialise(tbl)
	return SerialiseObject(nil, tbl, 0)
end

local function OpenKey(contents, index)
	local found, i = findNext(contents, "\"", index, {' ', '\t', '\n'})

	if found then
		local start = i
		local found, i = findUntil(contents, "\"", start + 1)

		if found then
			return contents:sub(start + 1, i - 1), i
		else
			return nil, i
		end
	end

	return nil, start
end

local function OpenPair(contents, index, tbl)
	local key, i = OpenKey(contents, index)

	if key then
		local value, i = OpenValue(contents, i + 1)

		if value then
			local found, j = false, 1

			found, j = findUntil(contents, ",", i + 1)
			if found then
				tbl[_key] = value
				return OpenPair(tbl, contents, j + 1)
			end
			
			found, j = findUntil(contents, "}", i + 1)
			if found then
				tbl[_key] = value
				return tbl, j
			end
		end
	end
end

local function OpenString(contents, index)
	local i = index
	local found, j = findUntil(contents, "\"", i + 1)

	if found then
		return contents:sub(i + 1, j - 1), j
	end

	return nil, j
end

local function OpenValue(contents, index)
	local found, i = findNext(contents, ":", index)

	if found then
		local _, i = findAny(contents, i, {' ', '\t', '\n'})

		local char = contents:sub(i, i)

		if(char == "\"") then
			return OpenString(contents, i)
		elseif(char == "{") then
			return OpenObject({}, contents, i)
		elseif(char == "[") then
			return OpenArray({}, contents, i)
		end
	end

	return nil, i
end

local function OpenObject(contents, index, tbl)
	local found, start = findNext(contents, "{", index, {' ', '\t', '\n'})

	if found then
		return OpenPair(contents, index, tbl)
	end

	return nil
end

function DeSerialise(contents)
	return OpenObject(contents, 1, {})
end

--[[
function Serialise(name, tbl, indent)
	local indent = indent or 0
	local str_indents 	= string.rep("	", indent)
	local str_contents 	= ""
	local i 			= 1
	local length 		= table.Count(tbl)
	local sequential 	= table.IsSequential(tbl)
	local char 	= {}

	char.open 	= "{"
	char.close 	= "}"

	if sequential and indent > 0 then
		char.open 	= "["
		char.close 	= "]"
	end

	if name then
		str_contents = str_indents .. "\"" .. name .. "\":" .. char.open .. "\n"
	else
		str_contents = str_indents .. char.open .. "\n"
	end

	for key, value in pairs(tbl) do
		local _type = TypeOf(value)

		if _type == "table" then
			str_contents = str_contents .. Serialise(key, value, indent + 1)
		else
			if _type == "string" then
				value = "\"" .. value .. "\""
			end

			if sequential then
				if i < length then
					str_contents = str_contents .. string.rep("	", indent + 1) .. string.format("%s,\n", value)
				else
					str_contents = str_contents .. string.rep("	", indent + 1) .. string.format("%s\n", value)
				end
			else
				if i < length then
					str_contents = str_contents .. string.rep("	", indent + 1) .. string.format("\"%s\": %s,\n", key, value)
				else
					str_contents = str_contents .. string.rep("	", indent + 1) .. string.format("\"%s\": %s\n", key, value)
				end
			end	

			i = i + 1
		end
	end

	if indent > 0 then
		return str_contents .. str_indents .. char.close .. ",\n"
	end

	return str_contents .. str_indents .. char.close .. "\n"
end

]]--

--[[
function mySerialiser.Serialise(_tablename, _table, _indent)
    local _indents    = Repeat("    ", _indent)
    local _string     = ""
    local _i          = 1
    local _length     = #_table

    if(_tablename ~= "") then
        _string = _indents .. "\"" .. _tablename .. "\": {\n"
    else
        _string = _indents .. "{\n"
    end

    for key, value in pairs(_table) do
        local _type = typeof(value)
        
        if _type == "table" then
            _string = _string .. mySerialiser.Serialise(key, value, _indent + 1)
        else
            if _type == "string" then
                value = "\"" .. value .. "\""
            end
            
            if _i < _length then
            _string = _string .. Repeat("    ", _indent + 1) .. string.format("\"%s\": %s,\n", key, value)
            else
            _string = _string .. Repeat("    ", _indent + 1) .. string.format("\"%s\": %s\n", key, value)
            end
        end 
        _i = _i + 1 
    end
    
    if _indent > 0 then
        return _string .. _indents .. "},\n"
    end
    
    return _string .. _indents .. "}\n"
end
]]--