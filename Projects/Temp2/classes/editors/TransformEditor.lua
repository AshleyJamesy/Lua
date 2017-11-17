local Class = CustomEditor("Transform")

function Class:OnSceneGui(target, targets)
	Handles.colour:Set(255,0,0,150)
	Handles.Slider(target.transform.position, Vector2(0, -1), 50)

	Handles.colour:Set(0,255,0,150)
	Handles.Slider(target.transform.position, Vector2(1, 0), 50)

	Handles.colour:Set(0,0,255,100)
	target.transform.rotation = Handles.RotationHandle(target.transform.position, target.transform.rotation, 60)
end