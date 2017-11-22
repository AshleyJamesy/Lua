local Class = class.NewClass("Object")

function Class:New()
	self.hideflag 	= {}
	self.name 		= self:Type()
end

function Class:GetInstanceID()
	
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

end

--Returns cloned object
function Class.Instantiate(original, position, rotation, parent)

end