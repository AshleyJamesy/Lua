local Class = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
    self.velocity     = Vector2(0,0)
    self.acceleration = Vector2(0,0)
end