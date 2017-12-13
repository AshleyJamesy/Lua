local Class = class.NewClass("CustomYieldInstruction")

local coroutine_CustomYieldInstruction = function(c, target, ...)
	while true do
		if c:KeepWaiting(...) then
			break
		end

		coroutine.yield()
	end
	
	coroutine.resume(target, ...)
end

function Class:New(target, ...)
	if not self.__class.yields then
		self.__class.yields = {}
	end

	local c = coroutine.create(coroutine_CustomYieldInstruction)
	table.insert(self.__class.yields, 1, c)

	coroutine.resume(c, self, target, self:Start(...))

	return coroutine.yield()
end

function Class:Start(...)
	return ...
end

function Class:DoYields()
	if self.__class.yields then
		self.__class.updating = true
		for i = 1, #self.__class.yields do
			if not coroutine.resume(self.__class.yields[i]) then
				table.remove(self.__class.yields, i)
			end
		end
		self.__class.updating = false
	end
end

function Class:KeepWaiting()
	return false
end