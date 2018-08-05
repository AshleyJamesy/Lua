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

		if v == "-hostip" then
			Arguments.HostIp = parameters[k + 1]
			k = k + 1
		end

		if v == "-connect" then
			Arguments.Connect = parameters[k + 1]
			k = k + 1
		end

		if v == "-port" then
			Arguments.Port = parameters[k + 1]
			k = k + 1
		end

		if v == "-maxplayers" then
			Arguments.MaxPlayers = parameters[k + 1]
			k = k + 1
		end
	end
	
	if Arguments.Server then
		local ip = 
			(Arguments.HostIp or "*") .. ":" .. (Arguments.Port or "6898")

		local maxplayers = 
			Arguments.MaxPlayers or 12

		print("Initalising Server")
		print("IP: " .. ip)
		print("Players: " .. "0/" .. maxplayers)

		Network:Init(ip, maxplayers or 12)
	else
		print("Initalising Client")

		Network:Init()
		Network:Connect("localhost:6898")
	end
end)

hook.Add("love.update", "game", function()
	
end)

hook.Add("love.render", "game", function()
	
end)


hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		for k, v in pairs(Network:GetConnections()) do
			Network:Disconnect(v:index(), "disconnected by user.")
		end
	end

	if key == "space" then
		Network:Connect("localhost:6898")
	end
end)
