module("console", package.seeall)

local thread = love.thread.newThread([[
	require("love.event")

	local line = ""	
	while true do
		io.flush()
		line = io.read()

		love.event.push("console_command", line)
	end
]])

thread:start()

local commands = {}

function AddCommand(name, callback)
	if type(name) ~= "string" then return end
	if type(callback) ~= "function" then return end

	commands[name] = callback
end

function RemoveCommand(name)
	if type(name) ~= "string" then return end

	commands[name] = nil
end

function love.handlers.console_command(line)
	if line then
		local arguments = string.split(line, " ")
		local command = arguments[1]

		if command then
			if commands[command] then
				local s, e = pcall(commands[command], line:sub(#command + 2, #line))
				if not s then
					print(e)
				end
			else
				print("command '" .. command .. "' does not exist")
			end
		end
	end
end