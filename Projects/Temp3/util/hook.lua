module("hook", package.seeall)

local Hooks = {}

function GetTable() 
	return Hooks
end

function Add(_event_name, _id, _function)
	if not IsFunction(_function) then return end
	if not IsString(_event_name) then return end
	
	if Hooks[_event_name] == nil then
		Hooks[_event_name] = {}
	end
	
	Hooks[_event_name][_id] = _function
end

function Remove(_event_name, _id)
	if not IsString(_event_name) then return end
	if Hooks[_event_name] == nil then return end
	
	Hooks[_event_name][_id] = nil
end

function Call(_event_name, ...)
	local HookTable = Hooks[_event_name]
	
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