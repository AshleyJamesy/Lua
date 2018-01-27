module("hook", package.seeall)

local Hooks     = {}
local Captures  = {}

function GetTable() 
	return Hooks
end

function Add(event, id, method)
	if not IsFunction(method) then return end
	if not IsString(event) then return end
	
	if Hooks[event] == nil then
		Hooks[event]    = {}
		Captures[event] = false
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
			
			if Captures[event] then
			    Captures[event] = false
			    
			    break
			end
			
			if a ~= nil then
				return a, b, c, d, e, f
			end
		end
	end
end

function Capture(event)
    Captures[event] = true
end