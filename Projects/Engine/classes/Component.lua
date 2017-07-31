local Class = class.NewClass("Component", "Object")
Class.limit = 0

function Class:New(gameObject)
	Class.Base.New(self)
	
	self.gameObject = gameObject
	self.tag = ""
	
	self.transform = (gameObject and gameObject.transform) and gameObject.transform or nil
	
	if self.gameObject then
		hook.Call("ComponentInitalised", self)
	end
end

function Class:Serialise()
	local t = {}

	if IsType(self, "Class") then
		t.__type = self:Type()
		t.__properties = {}

		for k, v in pairs(self) do
			if IsType(v, "Class") then
				if v:GetReference() then
				else
					t.__properties[k] = v:Serialise()
				end
			else
				if not IsType(v, "userdata") then
					t.__properties[k] = v
				end
			end
		end
	end
	
	return t
end

function Class:BroadcastMessage(method, ...)
	self.gameObject:BroadcastMessage(method, ...)
end

function Class:SendMessage(method, ...)
	self.gameObject:SendMessage(method, ...)
end

function Class:SendMessageUpwards(method, ...)
	
end

function Class:GetComponent(type)
	return self.gameObject:GetComponent(type)
end