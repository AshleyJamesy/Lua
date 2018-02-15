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

