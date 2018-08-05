local Class = class.NewClass("Network")
Class.Connections = {}

function Class:Connect(address)
	Class.host:connect(address)

	print("establishing connection to " .. address)
end

function Class:GetConnections()
	return Class.Connections
end

function Class:Init(address, connections_max, channels_max, incoming, outgoing)
	Class.host = ENET.host_create(address, connections_max, channels_max, incoming, outgoing)
end

function Class:SetChannelLimit(n)
	Class.host:channel_limit(n)
end

function Class:SetBandwidthLimit(incoming, outgoing)
	Class.host:bandwidth_limit(incoming, outgoing)
end

function Class:Broadcast(data, channel, flag)
	Class.host:broadcast(json.encode(data), channel, flag)
end

function Class:Peer(index)
	return Class.host:get_peer(index)
end

local disconnect_network = {
	hook = "OnDisconnect",
	data = {}
}
function Class:Disconnect(index, message)
	local peer = Class.host:get_peer(index)

	if message then
		disconnect_network.data[1] = message
		local encoded = json.encode(disconnect_network)
		peer:send(encoded)
	end

	peer:disconnect_later(1)
end

function Class:Latency(index)
	Class.host:get_peer(index):round_trip_time()
end

function Class:State(index)
	Class.host:get_peer(index):state()
end

function Class:Send(index, data, channel, flag)
	Class.host:get_peer(index):send(json.encode(data), channel, flag)
end

hook.Add("connection", "network", function(index, data)
	table.insert(Class.Connections, 1, Class.host:get_peer(index))

	print("connection established")
end)

hook.Add("disconnection", "network", function(index, data)
	for k, v in pairs(Class.Connections) do
		if index == v:index() then
			table.remove(Class.Connections, k)
		end
	end

	print("user disconnection")
end)

hook.Add("OnDisconnect", "network", function(index, message)
	print(index .. " " .. message)
end)