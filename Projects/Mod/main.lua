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
	local temp = INCLUDE_PATH
	INCLUDE_PATH = GetPath(path)
	
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
	
	INCLUDE_PATH = temp
end

include("lua/includes/util/json.lua")
include("lua/includes/modules/time.lua")
include("lua/includes/modules/timer.lua")
include("lua/includes/extensions/string.lua")
include("lua/includes/util/types.lua")
include("lua/includes/util/hook.lua")
include("lua/includes/util/utils.lua")
include("lua/includes/modules/console.lua")
include("lua/includes/modules/net.lua")
include("lua/includes/modules/downloads.lua")
include("lua/includes/modules/baseclass.lua")
include("lua/includes/modules/entity.lua")

ENT = {
	Base 			= "base_entity",
	ClassName 		= "", --comes from folder name
	Folder 			= "", --comes from the directory
	Spawnable 		= false, --Is it spawnable?
	Editable 		= false, --Is it editable?
	AdminOnly 		= false, --Is it admin spawnable/editable only?
	Author 			= "", --the author
	Contact 		= "", --author contact details
	Purpose 		= "", --what is this used for
	Instructions 	= "", --how is it used
	PrintName 		= "" --a better name than ie; base_entity
}

function LoadEntity(name)
	local script = {
		ENT 			= setmetatable({}, ENT),
		include 		= include,
		AddCSLuaFile 	= AddCSLuaFile,
		console 		= console,
		net 			= net,
		print 			= print
	}
	
	LoadLuaFile(GetProjectDirectory() .. "lua/entities/entities/" .. name .. "/init.lua", script)
	
	return script
end

local players = {}
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

	if SERVER then
		hook.Add("NetworkConnection", function(index)
			local id = #objects + 1
			
			objects[id] = 
			{
				owner 	= index,
				x 		= 0,
				y 		= 0
			}

			print(objects[id])
			players[index] = objects[id]

			net.Start("create")
			net.WriteInt(id)
			net.WriteFloat(0)
			net.WriteFloat(0)
			net.Broadcast()
		end)

		net.Receive("input", function(index)
			local key = net.ReadString()

			if players[index] then
				if key == "a" then
					players[index].x = players[index].x - 10
				end

				if key == "d" then
					players[index].x = players[index].x + 10
				end
			end
		end)
	end

	if CLIENT then
		net.Receive("create", function(index)
			objects[net.ReadInt()] = {
				x = net.ReadFloat(),
				y = net.ReadFloat()
			}
		end)

		net.Receive("update", function(index)
			local id = net.ReadInt()
			if objects[id] then
				objects[id].x = net.ReadFloat()
				objects[id].y = net.ReadFloat()
			end
		end)
	end
end

function love.update()
	if SERVER then
		for k, v in pairs(objects) do
			net.Start("update")
			net.WriteInt(k)
			net.WriteFloat(v.x)
			net.WriteFloat(v.y)
			net.Broadcast()
		end
	end

	if CLIENT then
		if love.keyboard.isDown("a") then
			net.Start("input")
			net.WriteString("a")
			net.Broadcast()
		end

		if love.keyboard.isDown("d") then
			net.Start("input")
			net.WriteString("d")
			net.Broadcast()
		end
	end
end

function love.render()
	if CLIENT then
		for k, v in pairs(objects) do
			love.graphics.rectangle("fill", v.x, v.y, 100, 100)
		end
	end
end