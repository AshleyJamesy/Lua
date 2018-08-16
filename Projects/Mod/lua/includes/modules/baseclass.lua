module("baseclass", package.seeall)

local BaseClassTable = {}

function Get(name)
	if ENT then 
		ENT.Base = name
	end
	
	if SWEP then
		SWEP.Base = name
	end
	
	BaseClassTable[name] = BaseClassTable[name] or {}
	
	return BaseClassTable[name]
end

function Set(name, baseclass)
	if not BaseClassTable[name] then
		BaseClassTable[name] = baseclass
	else
		table.Merge(BaseClassTable[name], baseclass)
		setmetatable(BaseClassTable[name], getmetatable(baseclass))
	end
	
	BaseClassTable[name].ThisClass = name
end

function DEFINE_BASECLASS(name)
	if not ENT then return end
	
	BaseClass = Get(name)
end