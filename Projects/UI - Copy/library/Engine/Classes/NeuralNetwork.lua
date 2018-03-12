local Class = class.NewClass("NeuralNetwork")

function Class:New()
	self.layers = {}
	self.output = {}
end

function Class:NewLayer(n)
	table.insert(self.layers, #self.layers + 1, NeuralLayer(n))
end

function Class:RemoveLayer(n)
	table.remove(self.layers, n)
end

function Class:SetInputs(...)
	local layer = self.layers[1]

	if layer then
		local arguments = { ... }
		for i = 1, #layer.input do
			layer.input[i] = arguments[i]
		end
	end
end

local function _forward(layer, next_layer)
	local input 	= layer.input
	local bias 		= layer.bias
	local weight 	= layer.weight
	local process 	= layer.process
	local output 	= next_layer.input

	for i = 1, #output do
		output[i] = 0.0
		
		for k = 1, #input do
			output[i] = (output[i] or 0) + weight[(i - 1) * #input + k] * input[k]
		end
		
		output[i] = process[i](output[i] * bias[i])
	end
end

function Class:Forward()
	for index, layer in pairs(self.layers) do
		local next_layer = self.layers[index + 1]

		if next_layer then
			_forward(layer, next_layer)
		else
			for k, v in pairs(layer.input) do
				self.output[k] = v
			end
		end
	end
end

function Class:SetWeightsRandom()
	for index, layer in pairs(self.layers) do
		local next_layer = self.layers[index + 1]
		if next_layer then
			layer:SetWeightsRandom(#next_layer.input)
		else
			break
		end
	end
end

function Class:GetGenetics()
	local genetics = {}
	for index, layer in pairs(self.layers) do
		local next_layer = self.layers[index + 1]
		
		if next_layer then
			for k, v in pairs(layer.weight) do
				table.insert(genetics, #genetics + 1, v)
			end
		end
		
		if index > 1 then
			for k, v in pairs(layer.bias) do
				table.insert(genetics, #genetics + 1, v)
			end
		end
	end
	
	return genetics
end

function Class:SetGenetics(genetics)
	local index = 1
	for index, layer in pairs(self.layers) do
		local next_layer = self.layers[index + 1]
		
		if next_layer then
			for i = 1, #layer.weight do
				layer.weight[i] = genetics[index]
				index = index + 1
			end
		end
		
		if index > 1 then
			for i = 1, #layer.bias do
				layer.bias[i] = genetics[index]
				index = index + 1
			end
		end
	end
end

function Class.Splice(geneticsA, geneticsB)
	local genetics = {}
	for i = 1, #geneticsA do
		if math.random() > 0.5 then
			genetics[i] = geneticsA[i]
		else
			genetics[i] = geneticsB[i]
		end
	end
	
	return genetics
end
