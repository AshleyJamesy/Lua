BIT  = require("bit")
FFI  = require("ffi")
ENET = require("enet")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")
  
class.Load()

hook.Add("love.load", "game", function(parameters)
<<<<<<< HEAD
	--Screen.Flip()
	camera = Camera(scene)
=======
    Screen.Flip()
<<<<<<< HEAD
    SceneManager:GetActiveScene()
    
    hashtable = HashTable()
   
    local go = GameObject()
    go:AddComponent("Camera")
    go:GetComponent("Camera").cameraType = CameraType.Game
    
    gameCam = go:GetComponent("Camera")
    
    for i = 1, 1000 do
        local go = GameObject()
        go:AddComponent("ShapeRenderer")
        go:AddComponent("Ball")
        
        go.transform.position.x = math.random() * 1000 - 500
        go.transform.position.y = math.random() * 1000 - 500
    end
>>>>>>> 499ce0cf1bf03dc42875d2a701657ba30283aba3
=======
>>>>>>> 9f3836a19cec90a7d7bb7fdfcedb5a9edfcb105b
end)

hook.Add("love.update", "game", function()
<<<<<<< HEAD
	Input.Update()

	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	
	GUI:BeginArea(0, 0, 350, 500, GUIOption.ExpandHeight(true))
		GUI:BeginHorizontal()
			GUI:Label(" Label", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Label("Label", GUIOption.Width(150), GUIOption.Height(25), GUIOption.Option("align", "center"))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Button", GUIOption.Width(150), GUIOption.Height(25))
			if GUI:Button("Button", GUIOption.Width(150), GUIOption.Height(25)) then 
				clicks = clicks + 1
			end
			GUI:Label(" " .. clicks, GUIOption.Width(25), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Checkbox", GUIOption.Width(150), GUIOption.Height(25))
			checkbox = GUI:CheckBox(checkbox, GUIOption.Width(25), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Slider", GUIOption.Width(150), GUIOption.Height(25))
			value = GUI:Slider(value, 50, 100, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Space(150)
		GUI:Label(string.format(" %0.1f, min:%d, max:%d", value, 50, 100), GUIOption.Width(180), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:Space(10)
		GUI:BeginHorizontal()
			GUI:Label(" Input", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Input(input_field, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Password", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Input(password_field, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
			GUI:Label(" RichTextBox\n (Lua Runnable)", GUIOption.Width(150), GUIOption.Height(25), GUIOption.Option("wrap", true))
			GUI:Input(textbox_field, GUIOption.Width(150), GUIOption.Height(100), GUIOption.Option("valign", "top"))
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
		GUI:Space(151)
		GUI:Input(textbox_output, GUIOption.Width(150), GUIOption.Height(50), GUIOption.Option("valign", "top"))
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
		GUI:Space(151)
		if GUI:Button("Run", GUIOption.Width(150), GUIOption.Height(25)) then
			local func, a, b, c = loadstring(textbox_field.text)
		 
			if func then
				local status output = pcall(func)
				if status then
				    textbox_output.text = tostring(output)
				end
			else
			    textbox_output.text = a
			end
		end
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
		GUI:Label(" ComboBox", GUIOption.Width(150), GUIOption.Height(25))
		local selection, changed = GUI:ComboBox(list_combobox, GUIOption.Width(150), GUIOption.Height(25))
		if images[selection] == nil then
		    images[selection] = love.graphics.newImage(selection)
		end
		
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Image", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Image(images[selection], GUIOption.Width(150), GUIOption.Height(150))
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
		GUI:Label(" Listbox", GUIOption.Width(150), GUIOption.Height(25))
		GUI:ListBox(listbox, GUIOption.Width(150), GUIOption.Height(100))
		GUI:EndHorizontal()
	GUI:EndArea()
=======
    Input.Update()
<<<<<<< HEAD
    SceneManager.activeScene:Update()
    
    GUI:Label(love.timer.getFPS(), GUIOption.Width(100), GUIOption.Height(25))
    
    SceneManager.activeScene:LateUpdate()
    
    Renderer.Batch()
>>>>>>> 499ce0cf1bf03dc42875d2a701657ba30283aba3
=======
>>>>>>> 9f3836a19cec90a7d7bb7fdfcedb5a9edfcb105b
end)

hook.Add("love.render", "game", function()
    GUI:Render()
    GUI:Show()
    
    Input.LateUpdate()
end)

hook.Add("KeyPressed", "game", function(key)
    if key == "escape" then
	       love.event.quit()
    end
end)