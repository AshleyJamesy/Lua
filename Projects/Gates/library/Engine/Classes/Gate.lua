local Class = class.NewClass("Gate")

function Class:New()
    self.action = nil
    
    self.Inputs  = {}
    self.Outputs = {}
end

function Class:Update()
    self.action.Output(self, unpack(self.Inputs))
end