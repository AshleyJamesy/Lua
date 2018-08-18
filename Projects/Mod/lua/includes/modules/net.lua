module("net", package.seeall)

local thread, channel

function Init(address, maxplayers, maxchannels, incoming, outgoing)
	channel = love.thread.newChannel()

	thread = love.thread.newThread([[
		local config, ch_send = ...

		require("love.event")
		local enet = require("enet")
		
		host = enet.host_create(config.address, config.maxplayers, config.maxchannels, config.incoming, config.outgoing)

		local states = {}
		for i = 1, config.maxplayers do
			states[i] = "disconnected"
		end

		while true do
			if host then
				host:flush()

				local packet = host:service()
				while packet do
					if packet.type == "receive" then
						love.event.push("network_message", packet.peer:index(), packet.data, packet.peer:round_trip_time())
					elseif packet.type == "connect" then
						love.event.push("network_connection", packet.peer:index())
					elseif packet.type == "disconnect" then
						love.event.push("network_disconnection", packet.peer:index(), packet.data)
					end
					
					packet = host:service()
				end

				for i = 1, config.maxplayers do
					if states[i] ~= host:get_peer(i):state() then
						states[i] = host:get_peer(i):state()

						love.event.push("network_state", i, states[i])
					end
				end

				local outgoing = ch_send:pop()
				while outgoing do
					if outgoing.action == "send" then
						if outgoing.to == nil then
							host:broadcast(outgoing.data, outgoing.channel, outgoing.flag)
						else
							if host:get_peer(outgoing.to) then
								host:get_peer(outgoing.to):send(outgoing.data, outgoing.channel, outgoing.flag)
							end
						end
					else
						if outgoing.action == "connect" then
							host:connect(outgoing.address)
						end

						if outgoing.action == "disconnect" then
							host:get_peer(outgoing.to):disconnect_later(1)
						end
					end

					outgoing = ch_send:pop()
				end
			end
		end
	]])

	local configuration = {
		address 		= address,
		maxplayers 		= maxplayers,
		maxchannels 	= maxchannels,
		incoming 		= incoming,
		outgoing 		= outgoing
	}

	thread:start(configuration, channel)
end

function Connect(address)
	if thread and channel then
		channel:push({
			action 	= "connect",
			address = address
		})
	end
end

local network_send_message 	= ""
local network_read_message 	= ""
local network_index 		= 1
local network_pack 			= love.data.pack
local network_unpack 		= love.data.unpack

function Start(message)
	network_send_message = network_pack("string", "s", message)
end

function WriteBool(bool)
	network_send_message = network_send_message .. network_pack("string", "B", bool and 1 or 0)
end

function ReadBool()
	local n, bytes = network_unpack("B", network_read_message, network_index)
	network_index = bytes

	return n == 1
end

function WriteInt(int)
	network_send_message = network_send_message .. network_pack("string", "j", int)
end

function ReadInt()
	local i, bytes = network_unpack("j", network_read_message, network_index)
	network_index = bytes

	return i
end

function WriteColour(r, g, b)
	network_send_message = network_send_message .. network_pack("string", "B", r)
	network_send_message = network_send_message .. network_pack("string", "B", g)
	network_send_message = network_send_message .. network_pack("string", "B", b)
end

function ReadColour()
	local r, bytes = network_unpack("B", network_read_message, network_index)
	network_index = bytes
	local g, bytes = network_unpack("B", network_read_message, network_index)
	network_index = bytes
	local b, bytes = network_unpack("B", network_read_message, network_index)
	network_index = bytes

	return r, g, b
end

function WriteFloat(float)
	network_send_message = network_send_message .. network_pack("string", "f", float)
end

function ReadFloat()
	local float, bytes = network_unpack("f", network_read_message, network_index)
	network_index = bytes

	return float
end

function WriteDouble(double)
	network_send_message = network_send_message .. network_pack("string", "d", double)
end

function ReadDouble()
	local double, bytes = network_unpack("d", network_read_message, network_index)
	network_index = bytes
	
	return double
end

function WriteString(string)
	network_send_message = network_send_message .. network_pack("string", "s", string)
end

function ReadString()
	print("reading string:", network_read_message, network_index)
	local string, bytes = network_unpack("s", network_read_message, network_index)
	network_index = bytes

	return string
end

function Send(player)
	
end

function SendToServer()
	
end

function Broadcast()
	channel:push({
		action 	= "send",
		data 	= network_send_message
	})

	network_send_message = ""
end

local callbacks = {}

function Receive(message, callback)
	if not callbacks[message] then
		callbacks[message] = {}
	end

	table.insert(callbacks[message], #callbacks[message] + 1, callback)
end

function love.handlers.network_message(index, data)
	network_index = 1
	
	local string, bytes = network_unpack("s", data, network_index)

	if callbacks[string] then
		for k, v in pairs(callbacks[string]) do
			network_index = bytes
			v(index)
		end
	end
end

function love.handlers.network_connection(index, data)
	hook.Call("NetworkConnection", index, data)
end

function love.handlers.network_disconnection(index, data)
	hook.Call("NetworkDisconnection", index, data)
end

function love.handlers.network_state(index, state)
	hook.Call("NetworkState", index, state)
end
