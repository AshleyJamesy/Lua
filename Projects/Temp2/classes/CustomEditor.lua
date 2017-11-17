local Class = class.NewClass("CustomEditor")
Class.Editors = {}

function Class:New(typename)
	if Class.Editors[typename] then
		return Class.Editors[typename]
	end
	
	local script = class.GetClass(typename)
	if script then
		script.__editor = self
		Class.Editors[typename] = self
	end
end

--Virtual Function
function Class:OnSceneGui(target, targets)
	
end