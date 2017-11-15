local Class = class.NewClass("Array")
Class.__mode = "kv"

function Class:New(t)
	return t and setmetatable(t, Class) or nil
end