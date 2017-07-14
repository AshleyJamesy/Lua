require "enet"

local RCHANNEL, SCHANNEL, IP, PORT, SERVER = ...

if SERVER then
    local host = enet.host_create(IP .. ":" .. PORT)
    RCHANNEL:push({"SERVER", host:get_socket_address()})
    while true do
        --update while loop every 100ms
        local event = host:service(100)
        while event do
            if event.type == "receive" then
            	RCHANNEL:push({"message", event.peer, event.data})
            elseif event.type == "connect" then
                RCHANNEL:push({"connect", event.peer})
            elseif event.type == "disconnect" then
                RCHANNEL:push({"disconnect", event.peer})
            end
        	
			--Send Packets
	        while true do
				local value = SCHANNEL:pop()
				if value then
					if value[1] == "all" then
						host:broadcast(value[2], 0, "reliable")
					end
				else
					break
				end
			end

        	event = host:service()

        end
    end
else
    local client = enet.host_create()
    RCHANNEL:push({"CLIENT", client:get_socket_address()})
    local server = client:connect(IP .. ":" .. PORT)
    while true do
        local event = client:service(100)
        while event do
            if event.type == "receive" then
            	RCHANNEL:push({"message", event.peer, event.data})
            elseif event.type == "connect" then
                RCHANNEL:push({"connect", event.peer})
            elseif event.type == "disconnect" then
                RCHANNEL:push({"disconnect", event.peer})
            end

        	--Send Packets
	        while true do
				local value = SCHANNEL:pop()
				if value then
					if value[1] == "all" then
						client:broadcast(value[2], 0, "reliable")
					end
				else
					break
				end
			end

        	event = client:service()
        end
    end
end