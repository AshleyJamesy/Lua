include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("GameManager", "MonoBehaviour")

function Class:Awake()
	self.players = {}
end

function Class:JoystickPressed(joystick, button)
	id = joystick:getID()
	if self.players[id] then
		return
	end

	local gameObject = GameObject()
	gameObject:AddComponent("Player")
	gameObject:AddComponent("LineRenderer")
	gameObject:GetComponent("Player").joystick = joystick

	self.players[id] = gameObject
end