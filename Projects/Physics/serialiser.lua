local mySerialiser    = {}
serialiser            = mySerialiser

local function Repeat(s, n)
    local _string = ""
    for i = 1, n do
        _string = _string .. s
    end
    
    return _string
end

local function length(_table) 
    local count = 0
    
    for _ in pairs(_table) do
        count = count + 1
    end
    
    return count 
end

--[[
function GetDir(_folder, _string, _indent)
    local _myIndent     = _indent
    local _filesystem   = love.filesystem
    local _files        = _filesystem.getDirectoryItems(_folder) 	
    
    for k, _filename in ipairs(_files) do
        local _file = _folder.."/".._filename
        
        if _filesystem.isFile(_file) then
            _string = _string .. "\n" .. Repeat("    ", _myIndent) .. "-" .. _filename
        else
            _string = _string .. "\n" .. Repeat("    ", _myIndent) .. _filename
        end
        
        if _filesystem.isDirectory(_file) then
            _string = _string .. ":"
            _string = GetDir(_file, _string, _indent + 1) 
        end
    end
    
    return _string
end
--]]

--[[
local EscapedChars = {
    "\\\"     = "\"",
    "\\\\"    = "\\",
    "\\/"     = "/",
    "\\b"     = "\b",
    "\\f"     = "\f",
    "\\n"     = "\n",
    "\\r"     = "\r",
    "\\t"     = "\t"
}
--]]

local function typeof(_variable)
    local _type = type(_variable)
    
    if(_type ~= "table" and _type ~= "userdata") then
        return _type; 
    end 
        
    local _meta = getmetatable(_variable)
    
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else 
        return _type;
    end
end

--[[JSON Decoding]]--

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

--[[JSON Decoding]]--

local OpenObject
local OpenPair
local OpenValue

local function Find(_string, _find, _start)
	local _ignore = {' ', '\t', '\n'}
	
	local i = _start
	while(i < #_string + 1) do
        local _char = string.byte(_string:sub(i, i))
		
		if(_char == string.byte(_find)) then
			return true, i
		else
			for j = 1, #_ignore do 
				if(_char == string.byte(_ignore[j])) then
					i = i + 1
					break
				end
				
				if(j == #_ignore) then return false, i end
			end
		end
	end
end

local function FindUntil(_string, _find, _start, ignore)
	local i = _start
	while(i < #_string + 1) do
        local _char = string.byte(_string:sub(i, i))
		
		if(_char == string.byte(_find)) then
			return true, i
		end
		
		i = i + 1
	end
	
	return false, i
end

local function OpenKey(_contents, indx, s)
	local _found_start, _start = Find(_contents, "\"", indx)
	
	if(_found_start == true) then
		local _found_end, _end = FindUntil(_contents, "\"", _start + 1)
		
		if(_found_end) then
			return _contents:sub(_start + 1, _end - 1), _end
		else
			return nil, _end
		end
	else
		return nil, _start 
	end
end

local function OpenString(_contents, indx)
	local _start 		= indx
	local _found, _end	= FindUntil(_contents, "\"", _start + 1)
	
	if(_found) then
		return _contents:sub(_start + 1, _end - 1), _end
	end
	
	return nil, _end
end

local function OpenNumber(_contents, indx)
	
end

local function OpenBool(_contents, indx)
	
end

OpenValue = function(_contents, indx)
	local _found, _start = Find(_contents, ":", indx)
	
	if(_found) then
		local _ignore = {' ', '\t', '\n'}
		
		local i = _start + 1
		local v = false
		
		while(i < #_contents + 1) do
			local _char = string.byte(_contents:sub(i, i))
			
			for j = 1, #_ignore do 
				if(_char == string.byte(_ignore[j])) then
					i = i + 1
					break
				end
				
				if(j == #_ignore) then
					v = true
					break
				end
			end
			
			if(v == true) then
				break
			end
		end
		
		if(_contents:sub(i, i) == "\"") then
			return OpenString(_contents, i)
		end
		
		if(_contents:sub(i, i) == "{") then
			return OpenObject({}, _contents, i)
		end
	end
end

OpenPair = function(t, _contents, indx)
	local _key, i = OpenKey(_contents, indx)
	
	if(_key == nil) then
	else
		local _value, i = OpenValue(_contents, i + 1)
		
		if(_value == nil) then
			
		else
			local _found	= false
			local j 		= 1
			
			_found, j = Find(_contents, ",", i + 1)
			if(_found) then
				t[_key] = _value
				return OpenPair(t, _contents, j + 1)
			end
			
			_found, j = Find(_contents, "}", i + 1)
			if(_found) then
				t[_key] = _value
				return t, j
			end
		end
	end
end

OpenObject = function(t, _contents, indx)
	local _found, _start = Find(_contents, "{", indx)
	
	if(_found == true) then
		return OpenPair(t, _contents, _start + 1)
	end
	
	return nil
end

function mySerialiser.DeSerialise(_file)
    local _contents, _size = love.filesystem.read(_file)
	
    return OpenObject({}, _contents, 1)
end











