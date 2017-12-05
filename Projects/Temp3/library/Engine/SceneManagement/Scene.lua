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
	
	self.__objects 	= {}
	self.__roots 	= {}
	self.__world 	= love.physics.newWorld(0, 0, true)
	--self.__world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)
end