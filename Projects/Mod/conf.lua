BUILD 	= false
SERVER 	= false
CLIENT 	= not SERVER

--io.stdout:setvbuf("no")

function love.conf(t)
	t.identity 				= nil 			-- The name of the save directory (string)
	t.version 				= "11.1" 		-- The LÖVE version this game was made for (string)
	t.console 				= false 		-- Attach a console (boolean, Windows only)
	t.accelerometerjoystick = false 		-- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
	t.externalstorage 		= false 		-- True to save files (and read from the save directory) in external storage on Android (boolean) 
	t.gammacorrect 			= true 			-- Enable gamma-correct rendering, when supported by the system (boolean)
	
	--Window
	t.window.title 			= "Window" 		-- The window title (string)
	t.window.icon 			= nil 			-- Filepath to an image to use as the window's icon (string)
	t.window.width 			= 800 			-- The window width (number)
	t.window.height 		= 600 			-- The window height (number)
	t.window.borderless 	= false 		-- Remove all border visuals from the window (boolean)
	t.window.resizable 		= true 			-- Let the window be user-resizable (boolean)
	t.window.minwidth 		= 1 			-- Minimum window width if the window is resizable (number)
	t.window.minheight 		= 1 			-- Minimum window height if the window is resizable (number)
	t.window.fullscreen 	= false 		-- Enable fullscreen (boolean)
	t.window.fullscreentype = "desktop" 	-- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
	t.window.vsync 			= false 		-- Enable vertical sync (boolean)
	t.window.msaa 			= 0 			-- The number of samples to use with multi-sampled antialiasing (number)
	t.window.display 		= 1 			-- Index of the monitor to show the window in (number)
	t.window.highdpi 		= false 		-- Enable high-dpi mode for the window on a Retina display (boolean)
	t.window.x 				= nil 			-- The x-coordinate of the window's position in the specified display (number)
	t.window.y 				= nil 			-- The y-coordinate of the window's position in the specified display (number)
	
	--Modules
	t.modules.audio 		= BUILD and BUILD or not SERVER 	-- Enable the audio module (boolean)
	t.modules.event 		= true 								-- Enable the event module (boolean)
	t.modules.graphics 		= BUILD and BUILD or not SERVER 	-- Enable the graphics module (boolean)
	t.modules.image 		= BUILD and BUILD or not SERVER 	-- Enable the image module (boolean)
	t.modules.joystick 		= BUILD and BUILD or not SERVER		-- Enable the joystick module (boolean)
	t.modules.keyboard 		= true 								-- Enable the keyboard module (boolean)
	t.modules.math 			= true 								-- Enable the math module (boolean)
	t.modules.mouse 		= true								-- Enable the mouse module (boolean)
	t.modules.physics 		= true 								-- Enable the physics module (boolean)
	t.modules.sound 		= BUILD and BUILD or not SERVER 	-- Enable the sound module (boolean)
	t.modules.system 		= true 								-- Enable the system module (boolean)
	t.modules.timer 		= true 								-- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
	t.modules.touch 		= BUILD and BUILD or not SERVER  	-- Enable the touch module (boolean)
	t.modules.video 		= BUILD and BUILD or not SERVER  	-- Enable the video module (boolean)
	t.modules.window 		= BUILD and BUILD or not SERVER 	-- Enable the window module (boolean)
	t.modules.thread 		= true 								-- Enable the thread module (boolean)
end

function love.run()
    if love.load then
        love.load(arg) 
    end
	
    if love.timer then 
        love.timer.step()
    end
    
    while true do
        net.Update()
    
        if love.event then
            love.event.pump()
        
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
        	
                love.handlers[name](a,b,c,d,e,f)
            end
        end
        
        local frameTime = 0.0
        
        if love.timer then
            love.timer.step()
            time.Delta  = love.timer.getDelta() * time.TimeScale
            frameTime   = love.timer.getDelta()
        end
		
        if love.fixedupdate then
            time.FixedTimeStepScaled = time.FixedTimeStep * time.TimeScale

            if frameTime > time.MaximumAllowedTimeStep then
                frameTime = time.MaximumAllowedTimeStep
			        end
			
            accumulator = accumulator + frameTime
			
            while accumulator >= time.FixedTimeStep do
                love.fixedupdate()
                accumulator = accumulator - time.FixedTimeStep
            end
			
            time.Alpha = accumulator / time.FixedTimeStep
        end

        if love.update then 
            love.update()
        end
        
        time.Elapsed = time.Elapsed + frameTime
        
        if love.graphics then
            if love.graphics.isActive() then
                love.graphics.clear(love.graphics.getBackgroundColor())
                love.graphics.origin()
				
                if love.render then 
                    love.render(time.Alpha)
                    love.graphics.present()
                end
            end
        end

        if love.timer then
            if time.MaxFrameRate > 0 then
				            --love.timer.sleep((1 / Time.MaxFrameRate) - accumulator)
            end
        end
    end
end