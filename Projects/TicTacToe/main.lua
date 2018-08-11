BIT 	= require("bit")
FFI 	= require("ffi")
ENET 	= require("enet")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load() 

local Arguments = {}
hook.Add("love.load", "game", function(parameters) 
    for k, v in pairs(parameters) do
        if v == "-server" then
            Arguments.Server = true
        end
    end
    
    if Arguments.Server then
        Network:Init("*:6898", 1000)
    else
        Network:Init("*:6898", 1)
        
        active = nil
    
        function button(id, x, y, w, h)
            love.graphics.rectangle("line", x, y, w, h)
    
            local mx, my = Input.mousePosition.x, Input.mousePosition.y
    
            if id == active then
                if not Input.GetMouseButton(1) then
                    if mx >= x and mx <= x + w then
                        if my >= y and my <= y + h then
                            active = nil
                            return true
                        end
                    end
            
                    active = nil
                end
            end
    
            if active == nil then
                if Input.GetMouseButton(1) then
                    if mx >= x and mx <= x + w then
                        if my >= y and my <= y + h then
                            active = id
                        end
                    end
                end
            end
            
            return false
        end    
    end
    
    size = 3
    board = {}
    for i = 0, size * size do
        board[i] = 0
    end
    
    renderTarget = RenderTarget()
end)

hook.Add("love.update", "game", function()
    Input.Update()
    
end)

hook.Add("ServerResponse", "game", function(peer, data)
    
end)

hook.Add("love.render", "game", function()
    love.graphics.reset()
    Screen.Draw(renderTarget.source, 0, 0, 0)
    
    Input.LateUpdate()
end)

hook.Add("KeyPressed", "game", function(key)
	
end)

hook.Add("TextInput", "game", function(char)
    Network:Broadcast(char)
end)
