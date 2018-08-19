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
include("lua/includes/modules/addon.lua")

function love.load(arguments)
	if SERVER then
		print("server")
		--net.Init("*:6898", 12)
	else
		print("client")
		--net.Init("*:6898", 1)
		--net.Connect("125.63.63.75:6898")
	end

	console.AddCommand("quit", function(line) 
		love.event.push("quit") 
	end)

	addon.LoadAddon("")
	addon.LoadAddons("addons/")
end