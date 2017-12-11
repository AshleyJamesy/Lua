local Class = class.NewClass("GameObject", "Object")

function Class:New(x, y)
	Class:Base().New(self)

	self.activeInHierarchy 	= false
	self.activeSelf 		= false
	self.isStatic			= false 	--EDITOR ONLY
	self.layer 				= 0
	self.scene 				= SceneManager:GetActiveScene()
	self.components 		= {}
	self.transform 			= self:AddComponent("Transform", x, y)
end

function Class:AddComponent(typename, ...)
	local c = class.GetClass(typename)
	
	if c and c.IsComponent then
		if c.__limit == nil or c.__limit > 0 then
			local j = 0
			for i = 1, #self.components do
				if typename == TypeOf(self.components[i]) then
					j = j + 1
					
					if j >= c.__limit then
						return self.components[i]
					end
				end
			end
			
			local instance = setmetatable({}, c)
			
			instance.gameObject = self
			instance.transform  = self.transform
			
			c.New(instance, self, ...)
			
			--This is done in by the Scene
			--if instance.IsMonoBehaviour then
			--	instance:Awake()
			--	instance:Start()
			--	instance:Enable()
			--end

			--instance.enabled = true
						
			table.insert(self.components, 1, instance)
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

--[[
function Class:Render()
	if DEBUG then
		love.graphics.setColor(0, 255, 0, 100)
		
		for k, fixture in pairs(self.__body:getFixtureList()) do
			local shape 		= fixture:getShape()
			local shape_type 	= shape:getType()

			if shape_type == "polygon" then
				love.graphics.polygon("line", self.__body:getWorldPoints(shape:getPoints()))
			elseif shape_type == "edge" then
				love.graphics.line(self.__body:getWorldPoints(shape:getPoints()))
			else
				love.graphics.circle("line", self.transform.position.x, self.transform.position.y, shape:getRadius())
			end
		end
		
		love.graphics.setColor(255,255,255,255)
	end
end
]]