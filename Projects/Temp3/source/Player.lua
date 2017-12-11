local Class = class.NewClass("Player", "MonoBehaviour")

local layer = 0
function Class:Update()
	if Input.GetKeyDown("up") then
		layer = layer + 1
		print(layer)
	end

	if Input.GetKeyDown("down") then
		layer = layer - 1
		print(layer)
	end

	if Input.GetMouseButton(1) then
		local object = GameObject(Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y))
		local sr = object:AddComponent("SpriteRenderer")

		object.layer = layer
		sr.colour:Set(255, 0, 0, 255)
		sr:PlayAnimation("idle")
		sr:SetDirty()
		local s = math.random() * 4
		object.transform.scale:Set(s, s)
	end

	if Input.GetMouseButtonDown(2) then
		local object = GameObject(Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y))
		local sr = object:AddComponent("SpriteRenderer")

		object.layer = layer
		sr.colour:Set(0, 255, 0, 255)
		sr:PlayAnimation("idle")
		sr:SetDirty()
		object.transform.scale:Set(5, 5)
	end

	if Input.GetMouseButton(5) then
		local object = GameObject(Camera.main:ScreenToWorld(Input.mousePosition.x, Input.mousePosition.y))
		local sr = object:AddComponent("SpriteRenderer")

		object.layer = layer
		sr.colour:Set(0, 0, 255, 255)
		sr:SetDirty()
	end
end