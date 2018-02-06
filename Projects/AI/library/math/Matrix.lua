local Class = class.NewClass("Matrix")

function Class:New(x, y)
    self.Rows    = x
    self.Columns = y
    
    self.values  = {}
    
    for i = 1, x * y do
        self.values[i] = 0.0
    end
end

function Class:Set(...)
    local arguments  = { ... }
    local new_values = self.values
    for i = 1, #arguments do
        new_values[i] = arguments[i]
    end
end

function Class.__mul(a, b)
    if a.Columns ~= b.Rows then
        error("cannot multiply matrix<" .. a.sizeX .. "," .. a.sizeY .. "> by matrix<" .. b.sizeX .. "," .. b.sizeY .. ">")
    end
    
    local matrix = class.Quick("Matrix", {
        Rows    = a.Rows,
        Columns = b.Columns,
        values  = {}
    })
    
    local new_values = matrix.values
    local a_values   = a.values
    local b_values   = b.values
    
    for i = 0, a.Rows - 1 do
        for j = 0, b.Columns - 1 do
            local vi = i * b.Columns + j + 1
            
            for k = 0, a.Columns - 1 do
                new_values[vi] = (new_values[vi] or 0) + 
                    a_values[i * a.Columns + k + 1] * b_values[k * b.Columns + j + 1]
            end
        end
    end
    
    return matrix
end

function Class:ToString()
    local output = ""
    for i = 0, self.Rows - 1 do
        for j = 0, self.Columns - 1 do
            output = output .. self.values[i * self.Columns + j + 1] .. ", "
        end
        
        output = output .. "\n"
    end
    
    return output
end

local a = Matrix(3, 2)
a:Set(4, 8, 0, 2, 1, 6)

local b = Matrix(2, 2)
b:Set(5, 2, 9, 4)

local c = a * b

print(c:ToString())