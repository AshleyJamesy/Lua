function GetFileDetails(filepath)
	local function greedy(str, cha)
		local j = nil
		for i = 1, #str do
			if str:sub(i, i) == cha then
				j = i
			end
		end
		
		return j
	end
	
	local i = greedy(filepath, "/")
	local j = greedy(filepath, ".")
	
	if i or j then    
		if i and j then
			if i > j then
				return filepath:sub(i + 1, #filepath), ""
			else
				return filepath:sub(i + 1, j - 1), filepath:sub(j + 1, #filepath)
			end
		else
			if i then
				return filepath:sub(i + 1, #filepath), ""
			end
			
			if j then
				return filepath:sub(1, j - 1), filepath:sub(j + 1, #filepath)
			end
		end
	end
	
	return filepath, ""
end

function GetPath(filepath)
	local function greedy(str, cha)
		local j = nil
		for i = 1, #str do
			if str:sub(i, i) == cha then
				j = i
			end
		end
	
		return j
	end
	
	local i = greedy(filepath, "/")
	if i then 
		return filepath:sub(1, i)
	end
	
	return ""
end

function LoadLuaFile(path, env)
	local include_temp 	= INCLUDE_PATH
	INCLUDE_PATH 		= GetPath(path)
	
	local contents, size = love.filesystem.read(path)
	if contents then
		env = env or {}
		env._G = env
		
		local chunk, err = loadstring(contents)
		
		if not chunk then
			print("compile error: '" .. path .. "' " .. err)
		else
			setfenv(chunk, env)
			
			local success, err = pcall(chunk)
			if not success then
				print("runtime error: '" .. path .. "' " .. err)
			end
		end
	end
	
	INCLUDE_PATH = include_temp
end

include("lua/includes/extensions/math.lua")
include("lua/includes/util/json.lua")
include("lua/includes/modules/time.lua")
include("lua/includes/modules/timer.lua")
include("lua/includes/extensions/string.lua")
include("lua/includes/util/types.lua")
include("lua/includes/util/hook.lua")
include("lua/includes/util/utils.lua")
include("lua/includes/modules/console.lua")
include("lua/includes/modules/class.lua")
include("lua/includes/modules/net.lua")
include("lua/includes/modules/downloads.lua")
include("lua/includes/modules/baseclass.lua")
include("lua/includes/modules/entity.lua")
include("lua/includes/modules/addon.lua")
include("lua/includes/modules/physics.lua")

local objects = {}

function love.load(arguments)
	if SERVER then
		print("server")
		net.Init("*:6898", 12)
	else
		print("client")
		net.Init("*:6898", 1)
		net.Connect("125.63.63.75:6898")
	end

	console.AddCommand("quit", function(line) 
		love.event.push("quit") 
	end)

	physics.Init()
	
	addon.LoadAddon("")
	addon.LoadAddons("addons/")

	if SERVER then
		net.Receive("MouseDown", function(index)
			local id = #objects + 1
			
			local object = {
				body = physics.AddPhysicsBody(love.mouse.getX(), love.mouse.getY(), "dynamic")
			}

			local fixture = love.physics.newFixture(object.body, love.physics.newCircleShape(10), 1.0)

			objects[id] = object

			net.Start("Create")
			net.WriteInt(id)
			net.WriteFloat(love.mouse.getX())
			net.WriteFloat(love.mouse.getY())
			net.Broadcast(true)
		end)
	else
		net.Receive("Create", function(index)
			local id = net.ReadInt()
			local x = net.ReadFloat()
			local y = net.ReadFloat()

			objects[id] = {
				id = id,
				x = x,
				y = y
			}
		end)

		net.Receive("Update", function(index)
			local id = net.ReadInt()
			local x = net.ReadFloat()
			local y = net.ReadFloat()

			local object = objects[id]

			if object then
				object.x = x
				object.y = y
			end
		end)
	end
end

function love.update()
	if SERVER then
		physics.Update(time.Delta)
		physics.WaitForPhysicsUpdate()

		for k, v in pairs(objects) do
			if v.body then
				net.Start("Update")
				net.WriteInt(k)
				net.WriteFloat(v.body:getX())
				net.WriteFloat(v.body:getY())
				net.Broadcast(false)
			end
		end
	else
		if love.mouse.isDown(1) then
			net.Start("MouseDown")
			net.WriteBool(true)
			net.Send(1, true)
		end
	end
end

function love.render()
	if SERVER then
		
	else
		for k, v in pairs(objects) do
			love.graphics.circle("line", v.x, v.y, 10)
		end

		love.graphics.print(love.timer.getFPS() .. "\n" .. #objects, 0, 0)
	end
end