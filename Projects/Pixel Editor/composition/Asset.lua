include("class")
include("composition/Object")

local Class, BaseClass = class.NewClass("Asset", "Object")
Asset = Class
Asset.Assets = {}

local function GenerateUniqueIdentifier()
    local template ='xxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'

    return string.gsub(template, '[xy]', 
    	function (c)
        	local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        	return string.format('%x', v)
    	end
    )
end

function Class:New()
	self.id = GenerateUniqueIdentifier()
end

--Virtual Function
function Class:Load()
	
end

function Class:Serialise()
	return { "Asset", self.id }
end