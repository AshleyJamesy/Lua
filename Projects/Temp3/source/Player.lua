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
end