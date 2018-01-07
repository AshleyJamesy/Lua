local Class = class.NewClass("Move", "MonoBehaviour")

function Class:Update()
	local x, y = Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y)
	self.transform.position:Set(x, y)
end