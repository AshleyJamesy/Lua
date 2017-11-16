local Class = class.NewClass("Asset")
Class.extension  = "asset"
Class.assets     = {}

function Class:New(path)
    print("test")
    return Class.assets[path] or Class.LoadAsset(path, self:Type())
end

function Class:Load()
    
end

function Class.LoadAsset(path, extension)
    
end