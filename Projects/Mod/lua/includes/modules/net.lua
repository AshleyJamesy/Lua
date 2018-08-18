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
						love.event.push("network_connection", packet.peer:index(), packet.data)
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
					if outgoing.type == "packet" then
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

function love.handlers.network_message(index, data)
	hook.Call("NetworkMessage", index, data)
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
