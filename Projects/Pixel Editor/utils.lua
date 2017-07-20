includes	= {}

function GetProjectDirectory()
    return git 
end

function include(file)
	local include_path = string.gsub(GetProjectDirectory(), "/", ".")
	local file_path = string.gsub(file, "/", ".")
	local full_path = include_path .. file_path

	if includes[full_path] then 
		return
	end

    includes[full_path] = true

	local file = require(full_path)
    
	return file
end

function path(file)
    return GetProjectDirectory() .. file
end

function dump(o, mi, i)
    mi = mi or 2
    i = i or 0
    local _string = ""
    
    if IsType(o, "class") then
        if o:Type().__tostring then
            _string = _string .. o:Type().__tostring(o) .. "\n"
        else
            for k, v in pairs(o) do
                _string = _string .. "\n" .. string.rep("    ", i) .. k .. " = " .. dump(v, mi, i + 1)
            end
        end
    else
        if IsTable(o) then
        
        else
            _string = _string .. tostring(o)
        end
    end
    
    return _string
end