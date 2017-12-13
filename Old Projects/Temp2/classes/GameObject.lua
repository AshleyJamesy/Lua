local Class = class.NewClass("GameObject", "Object")

function Destroy(object, duration)
	
end

function Class:New(x,y)
	Class:Base().New(self)

	self.name 		= "GameObject"
	self.tag 		= ""
	self.transform 	= Transform(self)
	
	self.components = {
		self.transform
	}

	self.transform.position.x = x or 0
	self.transform.position.y = y or 0
end

function Class:AddComponent(name, ...)
	local c = class.GetClass(name)
	
	if c and c.IsComponent then
		if c.__limit == nil or c.__limit > 0 then
			local j = 0
			for i = 1, #self.components do
				if name == TypeOf(self.components[i]) then
					j = j + 1

					if j >= c.__limit then
						return self.components[i]
					end
				end
			end
			
			local instance = class.New(name, self, ...)

			instance.gameObject = self
			instance.transform  = self.transform
			
			instance:Call("Awake")
			instance:Call("Start")
			instance:Call("Enable")
			
			self.components[#self.components + 1] = instance
		end
	end
	
	return self.components[#self.components]
end

function Class:RemoveComponent(name)
	local c = class.GetClass(name)
	if c and c.IsComponent then
		for i = #self.components, 1, -1 do
			if name == TypeOf(self.components[i]) then
				self.components[i] = nil
				return
			end
		end
	end
end

function Class:RemoveComponents(name)
	local c = class.GetClass(name)
	if c and c.IsComponent then
		for i = 1, #self.components do
			if name == TypeOf(self.components[i]) then
				self.components[i] = nil
			end
		end
	end
end

function Class:GetComponent(name)
	local c = class.GetClass(name)
	
	if c and c.IsComponent then
		for i = 1, #self.components do
			if name == TypeOf(self.components[i]) then
				return self.components[i]
			end
		end
	end

	return nil
end

function Class:GetComponents(name)
	local t = Array()

	local c = class.GetClass(name)
	if c and c.IsComponent then
		for i = 1, #self.components do
			if name == TypeOf(self.components[i]) then
				t[#t + 1] = self.components[i]
			end
		end
	end
	
	return t
end

function Class:SendMessage(method, req, ...)
	local result = false
	for k, v in pairs(self.components) do
		local f = v[method]
		if f and type(f) == "function" then
			f(v, ...)
			result = true
		end
	end

	return req and result or nil
end

--Quicker to check for this function than loop through types
function Class:IsGameObject()
	return true
end