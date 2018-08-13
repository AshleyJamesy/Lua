module("net", package.seeall)

local ENET = require("enet")

local host = nil
local connections = {}

function Connect(address)
	host:connect(address)

	print("connecting to '" .. address .. "'")
end

function GetConnections()
	local t = {}
	for k, v in pairs(connections) do
		t[k] = v
	end
	
	return t
end

function Init(address, connections_max, channels_max, incoming, outgoing)
	host = 
		ENET.host_create(address, connections_max, channels_max, incoming, outgoing)
end

function SetChannelLimit(n)
	host:channel_limit(n)
end

function SetBandwidthLimit(incoming, outgoing)
	host:bandwidth_limit(incoming, outgoing)
end

function Broadcast(data, channel, flag)
	host:broadcast(json.encode(data), channel, flag)
end

function Peer(index)
	return host:get_peer(index)
end

function Disconnect(index, message)
	local peer = Class.host:get_peer(index)

	--if message then
		--disconnect_network.data[1] = message
		--local encoded = json.encode(disconnect_network)
		--peer:send(encoded)
	--end

	peer:disconnect_later(1)
end

function Latency(index)
	host:get_peer(index):round_trip_time()
end

function State(index)
	host:get_peer(index):state()
end

function Send(index, data, channel, flag)
	host:get_peer(index):send(json.encode(data), channel, flag)
end

function love.handlers.incoming_message(index, data)
	print(data)
end

function love.handlers.peer_connection(index, data)
	print("connection established")
end

function love.handlers.peer_disconnection(index, data)
	print("disconnection")
end

function Update()
	if host then
		host:flush()

		local packet = host:service()
		while packet do
			if packet.type == "receive" then
				love.event.push("incoming_message", packet.peer:index(), packet.data)
			elseif packet.type == "connect" then
				love.event.push("peer_connection", packet.peer:index(), packet.data)
			elseif packet.type == "disconnect" then
				love.event.push("peer_disconnection", packet.peer:index(), packet.data)
			end
			
			packet = host:service()
		end
	end
end

--[[
hook.Add("connection", "network", function(index, data)
	table.insert(connections, 1, Class.host:get_peer(index))

	print("connection established")
end)

hook.Add("disconnection", "network", function(index, data)
	for k, v in pairs(connections) do
		if index == v:index() then
			table.remove(connections, k)
		end
	end

	print("user disconnection")
end)

hook.Add("OnDisconnect", "network", function(index, message)
	print(index .. " " .. message)
end)
]]
