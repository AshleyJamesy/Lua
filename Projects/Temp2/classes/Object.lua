local Class = class.NewClass("Object")

Hideflags = enum{
	"None",
	"HideInHierachy",
	"HideInInspector",
	"DontSaveInEditor",
	"NotEditable",
	"DontSaveInBuild",
	"DontUnloadUnusedAsset",
	"DontSave",
	"HideAndDontSave"
}

function Class:New()
	local object = class.GetClass(self:Type())
	object.__count = 1 + (object.__count or 0)
	
	self.id = object.__count

	self.hideflag 	= {}
	self.name 		= self:Type()
	
	self.__aabb 	= { w = 0, h = 0 }
end

function Class:ToString()
	return self.name
end