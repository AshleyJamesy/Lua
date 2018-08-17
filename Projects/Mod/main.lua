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
	Base            = "base_entity",
 ClassName       = "", --comes from folder name
	Folder          = "", --comes from the directory
	Spawnable       = false, --Is it spawnable?
	Editable        = false, --Is it editable?
 AdminOnly      	= false, --Is it admin spawnable/editable only?
	Author          = "", --the author
	Contact         = "", --author contact details
	Purpose         = "", --what is this used for
	Instructions    = "", --how is it used
	PrintName       = "" --a better name than ie; base_entity
}

function LoadEntity(name)
	local script = {
	    ENT = setmetatable({}, ENT),
	    include = include,
	    AddCSLuaFile = AddCSLuaFile,
	    print = print
	}
	
	LoadLuaFile(GetProjectDirectory() .. "lua/entities/entities/" .. name .. "/init.lua", script)
 
 return script
end

local entities = {}

function love.load(arguments)
	if SERVER then
		print("starting server")
		net.Init("*:6898", 32)
	else
		print("starting client")
		net.Init("*:6898", 1)
		net.Connect("125.63.63.75:6898")
	end
	
	if SERVER then
     local enti = LoadEntity("my_entity")
 end
 
 console.AddCommand("quit", function()
 	    love.event.push("quit")
 	end)
 	
 	if SERVER then
 	hook.Add("Connection", "downloads", function(index, packet)
 	    for k, v in pairs(downloads.GetContentListByType("script")) do
 	        print("sending client data")
 	        net.Send(index, { type = "script", data = v })
 	    end
 	end)
 	else
 hook.Add("IncomingMessage", "downloads", function(index, packet)
 	    local data = json.decode(packet)
 	    print(dump(data))
 	end)
 	end
end

local commandline = ""
function love.keypressed(key)
	if key == "escape" then
		if love.keyboard.hasTextInput() then
			love.keyboard.setTextInput(false)
		else
			love.event.push("quit")
		end
	end

	if key == "return" then
		if love.keyboard.hasTextInput() then
			love.keyboard.setTextInput(false)
			console.Run(commandline)
			commandline = ""
		end
	end
end

function love.textinput(char)
	commandline = commandline .. char
	log[#log] = log[#log] .. char
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	if not love.keyboard.hasTextInput() then
		love.keyboard.setTextInput(true)
	end
end

function love.update()
	if console then
		console.Update()
	end
end

function love.render()
    
end