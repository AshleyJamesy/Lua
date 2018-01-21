module("hook", package.seeall)

local Hooks = {}

function GetTable() 
	return Hooks
end

function Add(event, id, method)
	if not IsFunction(method) then return end
	if not IsString(event) then return end
	
	if Hooks[event] == nil then
		Hooks[event] = {}
	end
	
	Hooks[event][id] = method
end

function Remove(event, id)
	if not IsString(event) then return end
	if Hooks[event] == nil then return end
	
	Hooks[event][id] = nil
end

function Call(event, ...)
	local HookTable = Hooks[event]
	
	if HookTable ~= nil then
		local a, b, c, d, e, f
		
		for k, v in pairs(HookTable) do 
			if IsString(k) then
				a, b, c, d, e, f = v(...)
			else
				if TypeOf(k) ~= nil then
					a, b, c, d, e, f = v(k, ...)
				else
					HookTable[k] = nil
				end
			end
			
			if a ~= nil then
				return a, b, c, d, e, f
			end
		end
	end
end

local meta_HookTable = {}
meta_HookTable.__index = meta_HookTable
meta_HookTable.__call = function(t, ...)
	for k, v in pairs(t) do
		if v.target then
			v.method(v.target, ...)
		else
			v.method(...)
		end
	end
end

meta_HookTable.Subscribe = function(t, target, method)
	if not IsFunction(method) then return end
	for k, v in pairs(t) do
		if v.target == target and v.method == method then
			break
		end
	end

	local pair = {}
	pair.target = target
	pair.method = method

	table.insert(t, 1, pair)
end

meta_HookTable.UnSubscribe = function(t, target, method)
	if not IsFunction(method) then return end
	for k, v in pairs(t) do
		if v.target == target and v.method == method then
			table.remove(t, k)
			break
		end
	end
end

function CreateHookTable()
	return setmetatable({}, meta_HookTable)
end