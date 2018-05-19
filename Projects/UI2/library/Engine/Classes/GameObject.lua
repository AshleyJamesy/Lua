local Class = class.NewClass("GameObject", "Object")

function Class:New(x, y)
	Class:Base().New(self)
	
	self.gameObject 		= self
	
	self.layer 				= 0
	self.components 		= {}
	self.transform 			= self:AddComponent("Transform", x, y)
	self.__selected 		= false
end

function Class:AddComponent(typename, ...)
	local c = class.GetClass(typename)
	
	if c and c.IsComponent then
		if c.__limit == nil or c.__limit > 0 then
			local j = 0
			for i = 1, #self.components do
				if typename == TypeOf(self.components[i]) then
					j = j + 1
					
					if c.__limit ~= nil and j >= c.__limit then
						return self.components[i]
					end
				end
			end
			
			local instance = setmetatable({}, c)
			
			instance.gameObject = self
			instance.transform  = self.transform
			
			c.New(instance, self, ...)
			
			if instance.IsMonoBehaviour then
			  instance:Awake()
			  instance:Start()
			--instance:Enable()
			end
    
			--instance.enabled = true
			
			table.insert(self.components, 1, instance)
		end
	else
    if c == nil then
        print("Class <" .. typename .. "> does not exist")
    else
        if c.IsComponent then
            print("Class <" .. typename .. "> is not of type Component") 
        end
    end
	end
	
	return self.components[1]
end

function Class:GetComponent(typename)
	local c = class.GetClass(typename)
	
	if c and c.IsComponent then
		for i = 1, #self.components do
			if typename == TypeOf(self.components[i]) then
				return self.components[i]
			end
		end
	end
	
	return nil
end

function Class:GetComponents(typename)
	local t = {}
	
	local c = class.GetClass(typename)
	if c and c.IsComponent then
		for i = 1, #self.components do
			if typename == TypeOf(self.components[i]) then
				t[#t + 1] = self.components[i]
			end
		end
	end
	
	return t
end

function Class:BroadcastMessage(method, ...)
	for _, component in pairs(self.components) do
		if component[method] then
			component[method](component, ...)
		end
	end

	for _, child in pairs(self.transform.children) do
		child.gameObject:BroadcastMessage(method, ...)
	end
end

function Class:SendMessage(method, ...)
	for _, component in pairs(self.components) do
		if component[method] then
			component[method](component, ...)
		end
	end
end

function Class:OnDestroy()
	for _, component in pairs(self.components) do
		Object.Destroy(component)
	end
end