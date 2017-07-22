include("class")
include("composition/MonoBehaviour")

local Class, BaseClass = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
	self.joystick = nil
end

function Class:Update()
	if self.joystick then
		local x = self.joystick:getAxis(1)
		local y = self.joystick:getAxis(2)
		
		self.transform:Translate(x, y)
	end
end