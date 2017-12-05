local Class = class.NewClass("Delegate")

function Class:__call(...)
	for k, v in pairs(self.hook) do
		v(...)
	end
end

function Class:New()
	self.hook = {}
end

function Class:__add(pair)
	if not IsFunction(pair) and not IsType(pair, "DelegatePair") then return self end
	local key = IsFunction(pair) and pair or pair.target or pair.method

	if self.hook[key] then
		return self
	end

	self.hook[key] = IsFunction(pair) and pair or pair.method

	return self
end

function Class:__sub(pair)
	if not IsFunction(pair) and not IsType(pair, "DelegatePair") then return self end
	local key = IsFunction(pair) and pair or pair.target or pair.method

	if not self.hook[key] then
		return self
	end

	self.hook[key] = nil

	return self
end

