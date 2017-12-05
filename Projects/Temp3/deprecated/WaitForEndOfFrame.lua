local Class = class.NewClass("WaitForEndOfFrame", "CustomYieldInstruction")

function Class:KeepWaiting()
	return Class.updating
end