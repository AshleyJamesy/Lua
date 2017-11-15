local Class = class.NewClass("GameObject")

function Destroy(object, duration)
	
end

function Class:New()
	self.name 		= "GameObject"
	self.tag 		= ""
	self.transform 	= Transform(self)

	self.components = {
		self.transform
	}
end

function Class:AddComponent(name, ...)
	local c = class.GetClass(name)
	
	if c and c.__IsComponent then
		if c.__limit == nil or c.__limit > 0 then
			local j = 0
			for i = 1, #self.components do
				if name == TypeOf(self.components[i]) then
					j = j + 1

					if j >= c.__limit then
						return
					end
				end
			end
			
			local instance = class.New(name, self, ...)
			
			if instance.__IsMonoBehaviour then
				instance:Awake(...)
				instance:Start(...)
			end

			self.components[#self.components + 1] = instance
		end
	end
	
	return self.components[#self.components]
end

function Class:RemoveComponent(name)
	local c = class.GetClass(name)
	if c and c.__IsComponent then
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
	if c and c.__IsComponent then
		for i = 1, #self.components do
			if name == TypeOf(self.components[i]) then
				self.components[i] = nil
			end
		end
	end
end

function Class:GetComponent(name)
	local c = class.GetClass(name)
	if c and c.__IsComponent then
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
	if c and c.__IsComponent then
		for i = 1, #self.components do
			if name == TypeOf(self.components[i]) then
				t[#t + 1] = self.components[i]
			end
		end
	end
	
	return t
end

function Class:SendMessage(method, require, ...)
	local r = false
	for k, v in pairs(self.components) do
		local f = v[method]
		print(v:Type(), v[method])
		if f and type(f) == "function" then
			f(v, ...)
			r = true
		end
	end

	return r
end

--Quicker to check for this function than loop through types
function Class:IsGameObject()
	return true
end