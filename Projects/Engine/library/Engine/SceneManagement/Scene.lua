local Class = class.NewClass("Scene")

local function BeginContact(a, b, collision)
	local ua = a:getUserData()
	local ub = b:getUserData()
	ua:SendMessage("OnTriggerEnter", ub)
	ub:SendMessage("OnTriggerEnter", ua)
end

local function EndContact(a, b, collision)
	local ua = a:getUserData()
	local ub = b:getUserData()
	ua:SendMessage("OnTriggerExit", ub)
	ub:SendMessage("OnTriggerExit", ua)
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
end

function Class:Update()
	self.__world:update(Time.Delta)

	for k, v in pairs(self.__roots) do
		v:Update()
	end

	for k, v in pairs(self.__inactive) do
		if self.__objects[v.__typename] == nil then
			self.__objects[v.__typename] = {}
		end

		table.insert(self.__objects[v.__typename], 1, v)

		if v.IsMonoBehaviour then
			--v:Awake()
			--v:Start()
			v:Enable()
		end

		v.enabled = true

		table.remove(self.__inactive, k)
	end

	CallFunctionOnAll("Update", { "Transform" })
end

function Class:LateUpdate()
	CallFunctionOnAll("LateUpdate")
end

function Class:Render()
	CallFunctionOnType("Camera", "Render")
end

function Class:GetCount(typename)
	return self.__objects[typename] and #self.__objects[typename] or 0
end