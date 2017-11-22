local Class = class.NewClass("DelegatePair")

local constant_table = {}
constant_table["target"] 	= nil
constant_table["method"] 	= nil

function Class:New(target, method)
	constant_table["target"] = target
	constant_table["method"] = method

	return constant_table
end