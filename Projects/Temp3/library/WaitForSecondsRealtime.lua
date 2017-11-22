local Class = class.NewClass("WaitForSecondsRealtime", "CustomYieldInstruction")

function Class:Start(...)
	return love.timer.getTime(), ...
end

function Class:KeepWaiting(start, duration)
	return love.timer.getTime() - start > duration
end