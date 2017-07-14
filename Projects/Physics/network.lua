require "enet"

local channel, ip, port = ...

--ip   = ip or "localhost"
--port = port or 6789

local host = enet.host_create(ip .. ":" .. tostring(port))
while true do
    local event = host:service(100)
    while event do
        if event.type == "receive" then
            event.peer:send("pong")
            print("message: ", event.data, event.peer)
        elseif event.type == "connect" then
            print(event.peer, "connected")
        elseif event.type == "disconnect" then
            print(event.peer, "disconnected")
        end
        event = host:service()
    end    
end