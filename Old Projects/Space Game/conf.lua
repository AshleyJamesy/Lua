includes = {}

function GetProjectDirectory()
    return git or ""
end

function GetFileDetails(filename)
    local file  = string.reverse(filename)
    local i     = string.find(file, "%.")

    if i then
        return string.reverse(string.sub(file, i + 1)), string.reverse(string.sub(file, 1, i - 1))
    end

    return filename, ""
end

function include(file)
    if file:sub(#file,#file) == '/' then
        local folder = love.filesystem.getDirectoryItems(GetProjectDirectory() .. file)

        for k, v in pairs(folder) do
            local filename, extenstion = GetFileDetails(v)
            if      extenstion == "lua" then
                include(GetProjectDirectory() .. file .. filename)
            elseif  extenstion == "" then
                local full_path = GetProjectDirectory() .. file .. filename
                if love.filesystem.isDirectory(full_path) then
                    include(full_path .. "/")
                end
            else
                local full_path = GetProjectDirectory() .. file .. filename .. "." .. extenstion
                if love.filesystem.isDirectory(full_path) then
                    include(full_path .. "/")
                end
            end
        end

        return
    end
    
    local include_path  = string.gsub(GetProjectDirectory(), '/', '.')
    local file_path     = string.gsub(file, '/', '.')
    local full_path     = include_path .. file_path
    
    if includes[full_path] then
        return
    end
    
    includes[full_path] = true

    local file = require(full_path)
    
    return file
end

function love.conf(t)
    t.identity 				= nil           -- The name of the save directory (string)
    t.version 				= "0.10.2"      -- The LÖVE version this game was made for (string)
    t.console 				= false         -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = false      	-- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage 		= false         -- True to save files (and read from the save directory) in external storage on Android (boolean) 
    t.gammacorrect 			= false         -- Enable gamma-correct rendering, when supported by the system (boolean)
    
    --Window
    t.window.title 			= "Window"      -- The window title (string)
    t.window.icon 			= nil           -- Filepath to an image to use as the window's icon (string)
    t.window.width 			= 800           -- The window width (number)
    t.window.height 		= 600           -- The window height (number)
    t.window.borderless 	= false        	-- Remove all border visuals from the window (boolean)
    t.window.resizable 		= false         -- Let the window be user-resizable (boolean)
    t.window.minwidth 		= 1             -- Minimum window width if the window is resizable (number)
    t.window.minheight 		= 1             -- Minimum window height if the window is resizable (number)
    t.window.fullscreen 	= false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" 	-- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync 			= false         -- Enable vertical sync (boolean)
    t.window.msaa 			= 0             -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display 		= 1             -- Index of the monitor to show the window in (number)
    t.window.highdpi 		= false         -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.x 				= nil           -- The x-coordinate of the window's position in the specified display (number)
    t.window.y 				= nil           -- The y-coordinate of the window's position in the specified display (number)
 
    --Modules
    t.modules.audio 		= true          -- Enable the audio module (boolean)
    t.modules.event 		= true          -- Enable the event module (boolean)
    t.modules.graphics 		= true          -- Enable the graphics module (boolean)
    t.modules.image 		= true          -- Enable the image module (boolean)
    t.modules.joystick 		= true          -- Enable the joystick module (boolean)
    t.modules.keyboard 		= true          -- Enable the keyboard module (boolean)
    t.modules.math 			= true          -- Enable the math module (boolean)
    t.modules.mouse 		= true          -- Enable the mouse module (boolean)
    t.modules.physics 		= true          -- Enable the physics module (boolean)
    t.modules.sound 		= true          -- Enable the sound module (boolean)
    t.modules.system 		= true          -- Enable the system module (boolean)
    t.modules.timer 		= true          -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.touch 		= true          -- Enable the touch module (boolean)
    t.modules.video 		= true          -- Enable the video module (boolean)
    t.modules.window 		= true          -- Enable the window module (boolean)
    t.modules.thread 		= true          -- Enable the thread module (boolean)
end