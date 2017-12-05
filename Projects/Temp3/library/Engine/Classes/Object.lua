local Class = class.NewClass("Object")
local UUID 	= 1

function Class:New(id)
	self.hideflag 	= {}
	self.name 		= self:Type()

	self.__id = UUID
	UUID = UUID + 1

	if self.__batch == nil or self.__batch == true then
		if SceneManager:GetActiveScene().__objects[self.__typename] == nil then
			SceneManager:GetActiveScene().__objects[self.__typename] = {}
		end
		
		SceneManager:GetActiveScene().__objects[self.__typename][id or self.__id] = self
	end
end

function Class:GetInstanceID()
	return self.__id
end

function Class:ToString()
	return self.name
end

function Class.Destroy(object, time)

end

function Class.DestroyImmediate(object, allowDestroyingAssets)

end

function Class.DontDestroyOnLoad(object)

end

--Returns object of type
function Class.FindObjectOfType(typename)

end

--Returns list of objects of type
function Class.FindObjectsOfType(typename)
	local batch = SceneManager:GetActiveScene().__objects[typename]
	local list 	= {}
	
	if batch then
		for k, v in pairs(batch) do
			if table.HasValue(v.hideflag, "DontSave") then
			else
				if v.enabled == false then
				else
					table.insert(list, 1, v)
				end
			end
		end
	end
	
	return list
end

--Returns cloned object
function Class.Instantiate(original, position, rotation, parent)

end