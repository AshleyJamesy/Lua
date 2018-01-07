local Class = class.NewClass("Scene")

local function BeginContact(a, b, collision)
	--local ua = a:getUserData()
	--local ub = b:getUserData()
	--ua:SendMessage("OnTriggerEnter", ub)
	--ub:SendMessage("OnTriggerEnter", ua)
end

local function EndContact(a, b, collision)
	--local ua = a:getUserData()
	--local ub = b:getUserData()
	--ua:SendMessage("OnTriggerExit", ub)
	--ub:SendMessage("OnTriggerExit", ua)
end

local function PreSolve(a, b, collision)
	
end

local function PostSolve(a, b, collision, inormal, itangent)
	
end

function Class:New(name)
	self.buildIndex = 0
	self.isDirty 	= false
	self.isLoaded 	= false
	self.name 		= name
	
	self.__inactive = {}
	self.__objects 	= {}
	self.__roots 	= {}
	self.__world 	= love.physics.newWorld(0, 0, true)
	self.__world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)

	self.__layers = {
		Default = 0,
		UI 		= 1
	}
end

function Class:CallFunctionOnType(typename, method, ...)
	local batch = self.__objects[typename]
	if batch then
		local f = nil

		local index, component = next(batch, nil)
		while index do
			if f == nil then
				f = component[method]

				if f == nil or type(f) ~= "function" then
					f = nil
					break
				end
			end

			if component.enabled == nil or component.enabled == true then
				f(component, ...)
			end

			index, component = next(batch, index)
		end	
	end
end

function Class:CallFunctionOnAll(method, ignore, ...)
	for name, batch in pairs(self.__objects) do
		if ignore == nil then
			self:CallFunctionOnType(name, method, ...)
		else
			if table.HasValue(ignore, name) then
			else
				self:CallFunctionOnType(name, method, ...)
			end
		end
	end
end

function Class:Update()
	if self.__objects["SortingLayer"] then
		for k, v in pairs(self.__objects["SortingLayer"]) do
			print(k, v)
		end
	end

	self.__world:update(Time.Delta)

	for k, v in pairs(self.__roots) do
		v:Update()
	end

	for k, v in pairs(self.__inactive) do
		if self.__objects[v.__typename] == nil then
			self.__objects[v.__typename] = {}
		end
		
		table.insert(self.__objects[v.__typename], #self.__objects[v.__typename] + 1, v)
		
		if v.IsMonoBehaviour then
			--v:Awake()
			--v:Start()
			v:Enable()
		end

		v.enabled = true

		table.remove(self.__inactive, k)
	end
	
	Light.SendLights()
	
	self:CallFunctionOnAll("Update", { "Transform" })
end

function Class:LateUpdate()
	self:CallFunctionOnAll("LateUpdate")
end

function Class:Render()
	self:CallFunctionOnType("Camera", "Render")
end

function Class:GetCount(typename)
	return self.__objects[typename] and #self.__objects[typename] or 0
end