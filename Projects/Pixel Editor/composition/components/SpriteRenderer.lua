include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("SpriteRenderer", "MonoBehaviour")
SpriteRenderer = Class

function Class:Awake()
    self.sprite = nil
end

function Class:Render()
    
end