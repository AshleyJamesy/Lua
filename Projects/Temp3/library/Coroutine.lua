local Class = class.NewClass("Coroutine")
Class.Coroutines = {}

function Class:New(func, ...)
	self.coroutine = coroutine.create(func)
	table.insert(Class.Coroutines, 1, self.coroutine)
end

function Class:Status()
	return coroutine.status(self.coroutine)
end

function Class:Resume(...)
	return coroutine.resume(self.coroutine, self.coroutine, ...)
end

function Class:DoCoroutines()
	if Class.Coroutines then
		for i = 1, #Class.Coroutines do
			if coroutine.status(Class.Coroutines[i]) == "suspended" then
				if not coroutine.resume(Class.Coroutines[i]) then
					table.remove(Class.Coroutines, i)
				end
			end
		end
	end
end

--[[
function Class.Update()
	for i = 1, #Class.yields do
		if not coroutine.resume(yields[i]) then
			table.remove(yields, i)
		end
	end
end

local coroutine_WaitForSeconds = function(target, start, time)
	while true do
		if love.timer.getTime() - start > time then
			coroutine.resume(target)
			break
		end
		
		coroutine.yield()
	end
end

WaitForSeconds = function(target, time)
	local c = coroutine.create(coroutine_WaitForSeconds)

	table.insert(yields, 1, c)
	coroutine.resume(c, target, love.timer.getTime(), time)

	return coroutine.yield()
end
]]