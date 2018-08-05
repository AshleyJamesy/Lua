local Class = class.NewClass("HashTable")

function Class:New()
    self.count = {}
    self.data = {}
end

local function KeyRange(x, y, w, h, shift)
    --local sx 	= BIT.rshift(x or 0, shift)
    --local sy 	= BIT.rshift(y or 0, shift)
    --local ex 	= BIT.rshift(w or x or 0, shift)
    --local ey 	= BIT.rshift(h or y or 0, shift)
    
    local sx 	= math.ceil(x / shift)
    local sy 	= math.ceil(y / shift)
    local ex 	= math.ceil(w / shift)
    local ey 	= math.ceil(h / shift)
    
    return sx, ex, sy, ey
end

function Class.GetKeys(x, y, w, h, shift)
    local sx, ex, sy, ey = KeyRange(x, y, w, h, shift)
    
    local keys = {}
    
    for i = sy, ey do
        for j = sx, ex do
            table.insert(keys, #keys + 1, i .. ":" .. j)
        end
    end
    
    return keys
end

function Class:Add(x, y, w, h, shift, object)
    local sx, ex, sy, ey = KeyRange(x, y, w, h, shift)
    
    local data = self.data
    local count = self.count
    
    for i = sy, ey do
        if not data[i] then
            data[i] = {}
            count[i] = {}
        end
        
        for j = sx, ex do
            if not data[i][j] then
                data[i][j] = {}
                count[i][j] = 0
            end
            
            count[i][j] = count[i][j] + 1   
            data[i][j][count[i][j]] = object
            
            --print("adding", object, i, j)
        end
    end
end

--[[
function Class:Remove(id)
    for i, x in pairs(self.data) do
        for j, y in pairs(x) do
            if j == id then
                table.remove(y, id)
                self.count[i][j] = self.count[i][j] - 1
            end
        end
    end
end
]]

function Class:Get(x, y, w, h, shift)
    local sx, ex, sy, ey = KeyRange(x, y, w, h, shift)
    
    local data = self.data
    local count = self.count
    
    local objects = {}
    
    for i = sy, ey do
        if data[i] then
        for j = sx, ex do
            if data[i][j] then
                for k, object in ipairs(data[i][j]) do       
                    if k == count[i][j] + 1 then
                        break
                    end
                        
                    table.insert(objects, 1, object)
                end
            end
        end
        end
    end
    
    return objects
end

function Class:Count()
    local count = self.count
    local sum = 0
    
    for k, v in pairs(count) do
        for i, j in pairs(v) do
            sum = sum + v[j]
        end
    end
end

function Class:Empty()
    local count = self.count
    for k, v in pairs(count) do
        for i, j in pairs(v) do
            v[i] = 0
        end
    end
end