module("console", package.seeall)

local thread = love.thread.newThread([[
	local channel = ...
	
	local line = ""	
	while true do
		io.flush()
		line = io.read()

		channel:push(line)
	end
]])

local channel = love.thread.newChannel()
thread:start(channel)

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

function Update()
	local line = channel:pop()
	while line do
		local arguments = string.split(line, " ")
		local command = arguments[1]

		if command and commands[command] then
			local s, e = pcall(commands[command], line:sub(#command + 2, #line))
			if not s then
				print(e)
			end
		else
			print("command '" .. command .. "' does not exist")
		end
		
		line = channel:pop()
	end
end