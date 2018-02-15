local Class = class.NewClass("NeuralLayer")

local function sigmoid(value)
	return 1 / (1 + math.exp(-value))
end

function Class:New(n)
	self.input 		= {}
	self.bias 		= {}
	self.weight 	= {}
	self.process 	= {}
	
	
	for i = 1, n do
		self.input[i] 	= 0.0
		self.bias[i] 	= (love.math.random() - 0.5) / 0.5
		self.process[i] = sigmoid
	end
end

function Class:SetWeightsRandom(n)
	for i = 1, #self.input * n do
		self.weight[i] = (love.math.random() - 0.5) / 0.5
	end 
end