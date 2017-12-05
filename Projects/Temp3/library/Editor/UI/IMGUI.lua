require "imgui"

local function Update()
	imgui.NewFrame()
end
hook.Add("Update", "imgui", Update)

local function Render()
	imgui.Render()
end
hook.Add("OnGUI", "imgui", Render)

local function TextInput(text)
	imgui.TextInput(text)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("TextInput", "imgui", TextInput)

local function KeyPressed(key)
	imgui.KeyPressed(key)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("KeyPressed", "imgui", KeyPressed)

local function KeyReleased(key)
	imgui.KeyReleased(key)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("KeyReleased", "imgui", KeyReleased)

local function MousePressed(x, y, button)
	imgui.MousePressed(button)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("MousePressed", "imgui", MousePressed)

local function MouseReleased(x, y, button)
	imgui.MouseReleased(button)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("MouseReleased", "imgui", MouseReleased)

local function MouseMoved(x, y)
	imgui.MouseMoved(x, y)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("MouseMoved", "imgui", MouseMoved)

local function MouseWheelMoved(x, y)
	imgui.WheelMoved(y)
	if not imgui.GetWantCaptureKeyboard() then

	end
end
hook.Add("MouseWheelMoved", "imgui", MouseWheelMoved)

local function Destroy()
	imgui.Shutdown()
end