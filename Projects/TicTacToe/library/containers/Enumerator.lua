local Class = class.NewClass("Enumerator")

function enum(t)
	return Enumerator(t)
end

function Class:New(t)
	for k, v in pairs(t) do
		self[v] = k
	end
end