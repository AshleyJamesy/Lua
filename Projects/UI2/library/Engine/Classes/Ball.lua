local Class = class.NewClass("Ball", "MonoBehaviour")

function Class:New()
    Class:Base().New(self, gameObject)
end

function Class:Update()
    self.transform.position.y = self.transform.position.y + 10 * Time.Delta
end