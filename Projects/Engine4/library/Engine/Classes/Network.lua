local Class = class.NewClass("Network")
Class.Connected = {}

function Class:Connect(address)
	if Network.host == nil then
		Network.host = ENET.host_create()
	end

	Class.host:connect(address)
end

function Class:CreateServer(address, connections_max, channels_max, incoming, outgoing)
	Class.host = ENET.host_create(address, connections_max, channels_max, incoming, outgoing)
end

function Class:SetChannelLimit(n)
	Class.host:channel_limit(n)
end

function Class:SetBandwidthLimit(incoming, outgoing)
	Class.host:bandwidth_limit(incoming, outgoing)
end

function Class:Broadcast(data, channel, flag)
	Class.host:broadcast(data, channel, flag)
end

function Class:Peer(index)
	return Class.host:get_peer(index)
end

function Class:Kick(index, data)
	Class.host:get_peer(index):disconnect_later(data)
end

function Class:Latency(index)
	Class.host:get_peer(index):round_trip_time()
end

function Class:State(index)
	Class.host:get_peer(index):state()
end

function Class:Send(index, data, channel, flag)
	Class.host:get_peer(index):send(data, channel, flag)
end

hook.Add("connection", "network", function(index)
	table.insert(Class.Connected, 1, Class.host:get_peer(index))
end)

hook.Add("disconnection", "network", function(index)
	for k, v in pairs(Class.Connected) do
		if index == v:index() then
			table.remove(Class.Connected, k)
		end
	end
end)

hook.Add("incoming_packet", "network", function(index, data)
	
end)