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

Arguments = {}
hook.Add("love.load", "game", function(parameters)
	for k, v in pairs(parameters) do
		if v == "-server" then
			Arguments.Server = true
		end
	end

	if Arguments.Server then
		print("SERVER")
		love.window.setTitle("SERVER")
		Network:CreateServer("192.168.0.109:6898", 12)
		print(Network.host:get_socket_address())
	else
		print("CLIENT")
		love.window.setTitle("CLIENT")
		Network:Connect("192.168.0.109:6898")
		print(Network.host:get_socket_address())
	end
end)

hook.Add("love.update", "game", function()

end)

hook.Add("love.render", "game", function()
	if Arguments.Server then
		for i = 1, Network.host:peer_count() do
			local peer = Network.host:get_peer(i)
			local details = 
				"Latency: " .. peer:round_trip_time() .. "\n" .. 
				"State: " .. peer:state()

			love.graphics.print(details, 10, (i * 40) - 30)
		end
	end
end)

love.keyboard.setTextInput(true)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		love.event.quit()
	end
end)

hook.Add("TextInput", "game", function(char)
    Network:Broadcast(char)
end)