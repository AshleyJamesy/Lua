local Class = class.NewClass("Layer")

function Class:New(scene, name, index)
	self.scene 		= scene
	self.index	  	= index
	self.name	   	= name
	self.components = {}
end

function Class:Sort(type_name, sort_func)
	if self.components[type_name] then
		table.sort(self.components[type_name], sort_func)
	end
end

function Class:AddComponent(component)
	if component then
		if component:IsType("Component") then
			local batch = component:Type()
			
			if not self.components[batch] then
				self.components[batch] = {}
			end
			
			table.insert(self.components[batch], component)
		end
	end
end

function Class:RunFunctionOnType(method, type, ...)
	if self.components[type] then
		for _, component in pairs(self.components[type]) do
			--move to new layer but call it on this layer just this once
			--if component.gameObject.layer ~= self.index then
			--	self:MoveComponent(component, component.gameObject.layer)
			--end
			
			--check if component is enabled, if the variable doesn't exist treat it as enabled
			if not component.enabled or component.enabled == true then
				if method(component, self, ...) == true then
					break
				end
			end
		end
	end
end

function Class:RunFunctionOnAll(method, ignore, ...)
	local ignore_t = ignore or {}
	for name, batch in pairs(self.components) do
		if table.HasValue(ignore_t, name) then
		else
			self:RunFunctionOnType(method, name, ...)
		end
	end
end

function Class:CallFunctionOnType(method, type, sort, ...)
	--checking for sorting function. If one exists, run it before we iterate
	if sort then
		local component = class.GetClass(type)
		if component.Sort then
			table.sort(batch, component.Sort)
		end
	end

	if self.components[type] then
		for _, component in pairs(self.components[type]) do
			--if component.gameObject.layer ~= self.index then
			--	self:MoveComponent(component, component.gameObject.layer)
			--end

			--check if component is enabled, if the variable doesn't exist treat it as enabled
			if not component.enabled or component.enabled == true then
				--check if method exists in this component, if not then move on to next batch
				if component[method] then
					component[method](component, ...)
				else
					--break to next batch
					break
				end
			end
		end
	end
end

function Class:CallFunctionOnAll(method, ignore, sort, ...)
	local ignore_t = ignore or {}
	for name, batch in pairs(self.components) do
		if table.HasValue(ignore_t, name) then
		else
			self:CallFunctionOnType(method, name, sort, ...)
		end
	end
end

function Class:SetName(name)
	self.name = name
end

function Class:ToString()
	return self.name .. ":" .. self.index
end