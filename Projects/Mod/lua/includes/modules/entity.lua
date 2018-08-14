module("entity", package.seeall)

owner 	= nil
name 	= "entity"
class 	= "entity"

function Activate()
	--activate entity from inactive entities
end

function AddCallback(event, func)

end

function GetOwner()
	return self.owner
end

function SetOwner(entity)
	self.owner = entity
end

function SetName(name)
	self.name = name
end

function GetName()
	return self.name
end

function SetupDataTables()

end

function GetNetworkedBool(key, fallback)

end

function GetNetworkedInt(key, fallback)

end

function GetNetworkedFloat(key, fallback)

end

function GetNetworkedString(key, fallback)

end