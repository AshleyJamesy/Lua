tokens = {}
tokens["\\s"] = function(source, i, exp, expi)
    return source:sub(i, i) == " ", i, expi
end

tokens["\\S"] = function(source, i, exp, expi)
    return source:sub(i, i) ~= " ", i, expi
end

tokens["\\d"] = function(source, i, exp, expi)
    local char = source:sub(i, i)
    return string.byte(char) >= 48 and string.byte(char) <= 57, i, expi
end

tokens["."] = function(source, i, exp, expi)
    return true, i, expi
end

tokens["+"] = function(source, i, exp, expi)
    
end

--groups
tokens["("] = function(source, i, exp, expi)
    local char = source:sub(i, i)
    local backslash = false
    local match = false
    
    local j = expi + 1
    while true do
        if backslash then
            if char == exp:sub(j, j) then
                match = true
            end
            
            backslash = false
        else
            if exp:sub(j, j) == "\\" then
                backslash = true
            else
                if exp:sub(j, j) == ")" then
                    break
                end
                
                if char == exp:sub(j, j) then
                    match = true
                end
            end
        end
        	
        	j = j + 1
        	
        	if j > #exp then
        	    error("regex: no matching )")
        	end
    end
end

tokens["|"] = function(source, i, exp, expi)
    
end

tokens[")"] = function(source, i, exp, expi)
    
end

--constructs
tokens["["] = function(source, i, exp, expi)
    local char = source:sub(i, i)
    local backslash = false
    local match = false
    
    local j = expi + 1
    while true do
        if backslash then
            if char == exp:sub(j, j) then
                match = true
            end
            
            backslash = false
        else
            if exp:sub(j, j) == "\\" then
                backslash = true
            else
                if exp:sub(j, j) == "]" then
                    break
                end
                
                if char == exp:sub(j, j) then
                    match = true
                end
            end
        end
        	
        	j = j + 1
        	
        	if j > #exp then
        	    error("regex: no matching ]")
        	end
    end
    
    return match, i, j + 1
end

tokens["literal"] = function(source, i, exp, expi)
    return source:sub(i, i) == exp:sub(expi, expi), i, expi
end

function match(source, expression)
    local method = nil
    local j = 1
    
    local backslash = false
    
    local matches = {
        { fullmatch = "" }
    }
    
    for i = 1, #source do
        while not method do
            local char = expression:sub(j, j)
            
            if backslash then
                if tokens["\\" .. char] then
                    method = tokens["\\" .. char]
                else
                    method = tokens["literal"]
                end
                
                backslash = false
            else
                if char == "\\" then
                    backslash = true
                    j = j + 1
                else
                    if tokens[char] then
                        method = tokens[char]
                    else
                        method = tokens["literal"]
                    end
                end
            end
        end
        
        local match, i, j = method(source, i, expression, j) 
        if match then
        	    method = nil
        	    j = j + 1
        	    
        	    matches[#matches].fullmatch = 
        	        matches[#matches].fullmatch .. source:sub(i,i)
        	    
        	    if j > #expression then
        	        table.insert(matches, #matches + 1, { fullmatch = "" })
        	        j = 1
        	    end
        	else
        	    method = nil
        	    j = 1
        	    matches[#matches].fullmatch = ""
        	end
    end
    
    return matches
end


--for k, v in pairs(match("adghcge\\ba", "[\\]]")) do
--    print(v.fullmatch)
--end



