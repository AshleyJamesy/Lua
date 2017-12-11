local Class = class.NewClass("Test", "MonoBehaviour")

function Class:Update()
	self.transform.scale.x = 1 + math.sin(Time.Elapsed) * 0.2
	self.transform.scale.y = 1 + math.sin(Time.Elapsed) * 0.2
end