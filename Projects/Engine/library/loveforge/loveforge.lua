loveforge 		= {}
loveforge.nodes = {}

loveforge.node = class.NewClass("loveforge.connection")
function loveforge.node:New(from, to, output, input)
	self.from 	= from
	self.to 	= to
	self.output = output
	self.input 	= input
end

loveforge.node = class.NewClass("loveforge.node")
function loveforge.node:New()
	self.input 			= {}
	self.output 		= {}
	self.connections 	= {}
end

function loveforge.node:Update()
	
end

function loveforge.node:Changed()
	
end

function loveforge.node:Render()
	
end

function loveforge.node:SetInput(name, value)
	self.input[name] = value
end

function loveforge.node:GetInput(name)
	return self.input[name]
end

function loveforge.node:SetOutput(name, value)
	self.output[name] = value
end

function loveforge.node:Connect(input, output)
	
end