function dump(o, i)
    local i         = i or -1
    local output    = ""

        if type(o) == "table" then
            for k, v in pairs(o) do
                if type(v) == "table" then
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