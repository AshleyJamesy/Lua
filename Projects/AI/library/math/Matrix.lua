local Class = class.NewClass("Matrix")

function Class:New(x, y)
	self.rows 		= x
	self.columns 	= y
	
	self.values = {}
	for i = 1, x * y do
		self.values[i] = 0.0
	end
end

--[[
		description: 	returns the multiplication of a and b
		arguments:		[float, Matrix] a, [float, Matrix] b
		return: 		[Matrix] result
		notes: 			
]]
function Class.Multiply(a, b)
	if type(a) == "number" then
		local matrix = class.Quick("Matrix", {
			rows 	= b.rows,
			columns = b.columns,
			values 	= {}
		})

		for i = 1, x * y do
			matrix.values[i] = b.values[i] * a
		end

		return matrix
	end
	
	if type(b) == "number" then
		local matrix = class.Quick("Matrix", {
			rows 	= a.rows,
			columns = a.columns,
			values 	= {}
		})

		for i = 1, x * y do
			matrix.values[i] = a.values[i] * b
		end
		
		return matrix
	end
	
	if a.columns ~= b.rows then
		error("cannot multiply matrix<" .. a.rows .. "," .. a.columns .. "> by matrix<" .. b.rows .. "," .. b.columns .. ">", 2)
	end
	
	local n_values = {}
	local a_values = a.values
	local b_values = b.values
	
	for i = 0, a.rows - 1 do
		for j = 0, b.columns - 1 do
			local vi = i * b.columns + j + 1
			
			for k = 0, a.columns - 1 do
				n_values[vi] = (n_values[vi] or 0) + 
					a_values[i * a.columns + k + 1] * b_values[k * b.columns + j + 1]
			end
		end
	end
	
	return class.Quick("Matrix", { rows = a.rows, columns = b.columns, values = n_values })
end

--[[
		description: 	returns the multiplication of a and b
		arguments:		[float, Matrix] a, [float, Matrix] b
		return: 		[Matrix] result
		notes: 			
]]
function Class.__mul(a, b)
	return Class.Multiply(a, b)
end

--[[
		description: 	returns a copy of matrix a
		arguments:		nil
		return: 		[Matrix] copy
		notes: 			
]]
function Class.Copy(a)
	local values 	= {}
	for k, v in pairs(a.values) do
		values[k] = v
	end

	return class.Quick("Matrix", {
		rows 	= a.rows,
		columns = a.columns,
		values 	= values
	})
end

--[[
		description: 	returns a copy of matrix a
		arguments:		nil
		return: 		[Matrix] copy
		notes: 			
]]
function Class.__call(a)
	return Class.Copy(a)
end

--[[
		description: 	sets the values of this matrix
		arguments:		[float] ...
		return: 		nil
		notes: 			
]]
function Class:Set(...)
	local arguments = { ... }
	local n_values = self.values
	for i = 1, self.rows * self.columns do
		n_values[i] = arguments[i]
	end
end

--[[
		description: 	sets the column i of this matrix
		arguments:		[float] index, [float] ...
		return: 		nil
		notes: 			
]]
function Class:SetColumn(column, ...)
	local arguments 	= { ... }
	local n_values 		= self.values

	for i = 1, self.rows do
		n_values[(i - 1) * self.columns + column] = arguments[i]
	end
end

--[[
		description: 	sets the row i of this matrix
		arguments:		[float] index, [float] ...
		return: 		nil
		notes: 			
]]
function Class:SetRow(row, ...)
	local arguments 	= { ... }
	local n_values 		= self.values

	local index = row * self.columns - self.columns
	for i = 1, self.columns do
		n_values[index + i] = arguments[i]
	end
end

--[[
		description: 	sets a value in this matrix
		arguments:		[float] index, [float] value
		return: 		nil
		notes: 			index is in 1D form
]]
function Class:SetValue(index, value)
	self.values[index] = value
end

--[[
		description: 	swaps the values of a and b
		arguments:		[Matrix] a, [Matrix] b
		return: 		nil
		notes: 			must be of same size
]]
function Class.Swap(a, b)
	if a.rows == b.rows and a.columns == b.columns then
		local swap = b.values
		b.values = a.values
		a.values = swap
	else
		error("cannot swap matrix<" .. a.rows .. "," .. a.columns .. "> with matrix<" .. b.rows .. "," .. b.columns .. ">, size mismatch.", 2)
	end
end

--[[
		description: 	returns a row of this matrix
		arguments:		[float] row
		return: 		[float] ...
		notes: 			
]]
function Class:GetRow(row)
	local args = {}
	local index = row * self.columns - self.columns
	for i = 1, self.columns do
		args[i] = self.values[index + i]
	end

	return unpack(args)
end

--[[
		description: 	returns a column of this matrix
		arguments:		[float] column
		return: 		[float] ...
		notes: 			
]]
function Class:GetColumn(column)
	local args = {}
	for i = 1, self.columns do
		args[i] = self.values[(i - 1) * self.columns + column]
	end

	return unpack(args)
end

--[[
		description: 	returns the Matrix formatted as a string
		arguments:		nil
		return: 		[string] result
		notes: 			
]]
function Class:ToString()
	local output = ""
	for i = 0, self.rows - 1 do
		for j = 0, self.columns - 1 do
			output = output .. self.values[i * self.columns + j + 1] .. ", "
		end
		
		output = output .. "\n"
	end
	
	return output
end