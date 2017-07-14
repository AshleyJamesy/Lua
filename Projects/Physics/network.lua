require "enet"

local CHANNEL, IP, PORT, SERVER = ...

if SERVER then
    CHANNEL:push({"SERVER", IP .. ":" .. tostring(PORT)})
    local host = enet.host_create(IP .. ":" .. tostring(PORT))
    print(host:get_socket_address())
    while true do
        --update while loop every 100ms
        local event = host:service(100)
        while event do
            if event.type == "receive" then

            elseif event.type == "connect" then
                CHANNEL:push({"connect", event.peer})
            elseif event.type == "disconnect" then
                CHANNEL:push({"disconnect", event.peer})
            end
        event = host:service()
        end
    end
else
    CHANNEL:push({"CLIENT", IP .. ":" .. tostring(PORT)})
    local host = enet.host_create()
    print(host:get_socket_address())
    local server = host:connect(IP .. ":" .. tostring(PORT))
    while true do
        local event = host:service(100)
        while event do
            if event.type == "receive" then

            elseif event.type == "connect" then
                CHANNEL:push({"connect", event.peer})
            elseif event.type == "disconnect" then
                CHANNEL:push({"disconnect", event.peer})
            end
        event = host:service()
        end
    end
end