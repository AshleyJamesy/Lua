local Class = class.NewClass("Reference")
Class:SetReference(false)

function Class.MakeGraph(object, g)
	local global = g or {}

	local t = {}
	if type(object) == "table" then
		for k, v in pairs(object) do
			if type(v) == "table" then
				if global[tostring(v)] then
				else
					global[tostring(v)] = t
					
					if IsType(v, "Class") then
						if v:GetReference() then
							table.insert(t, tostring(v))
						end
					end
				end
			end
		end
	end

	return t
end