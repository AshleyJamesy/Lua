local Class = class.NewClass("Enumerator")

function Class:New(t)
	self.values = {}

	for k, v in pairs(t) do
		self.values[v] = k
	end
end

function enum(t)
	return Enumerator(t)
end