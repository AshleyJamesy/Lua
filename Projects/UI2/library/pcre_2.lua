local test

local mi = 1
local gi = 0
local matches = {
    {
    	    match = false,
    	    fullmatch = "",
    	    groups = {}
    	}
}

local function matchOne(source, pattern, i, k)
    if k > #pattern then
        matches[mi].match = true
        
        mi = mi + 1
        gi = 0
        matches[mi] = {
        	    match = false,
        	    fullmatch = "",
        	    groups = {}
        	}
        	
        return matchOne(source, pattern, i, 1)
    end
    
    local src, exp = source:sub(i, i), pattern:sub(k, k)
    
    if not pattern then
        return true, i, k + 1
    end
    
    if not source then
        return false, i, k + 1
    end
    
    if exp == "\\" then
        return matchOne(source, pattern, i, k + 1)
    end
    
    if exp == "(" then
        gi = gi + 1
        matches[mi].groups[gi] = ""
        
        local result, i, k = matchOne(source, pattern, i, k + 1)
        if not result then
            gi = gi - 1
        end
        
        return result, i, k
    end
    
    if exp == ")" then
        gi = gi - 1
        return matchOne(source, pattern, i, k + 1)
    end
    
    if exp == "." then
        for j = 1, gi do
            matches[mi].groups[j] = matches[mi].groups[j] .. src
        end
        
        matches[mi].fullmatch = matches[mi].fullmatch .. src
        
        return true, i, k + 1
    end
    
    if exp == "[" then
        
    end
    
    if exp == src then
        for j = 1, gi do
            matches[mi].groups[j] = matches[mi].groups[j] .. src
        end
        
        matches[mi].fullmatch = matches[mi].fullmatch .. src
        
        return true, i, k + 1
    end
    
    return false, i, k + 1
end

local function match(source, pattern)
    local k = 1
    
    for i = 1, #source do
        while true do
            local result
            result,  i, k = matchOne(source, pattern, i, k)
            if result then
                break
            else
               k = 1
               break
            end
        end
    end
end

match("abcdefghgdgabca", "(a(bc))*")

for match_index, match in pairs(matches) do
    print("Match " .. match_index)
    
    for group_index, value in pairs(match.groups) do
        print("\tGroup" .. group_index .. ". " .. value)
    end
end