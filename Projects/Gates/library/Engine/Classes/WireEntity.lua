local Class = class.NewClass("WireEntity")

function Class:New()
    self.name         = self.__typename
    self.input        = {}
    self.input_types  = {}
    self.output       = {}
    self.output_types = {}
end