function GetProjectDirectory()
	return git or ""
end

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
end

local include_path = ""
function include(path)
	local include_pathTemp = include_path
	include_path = include_path .. GetPath(path)

	local filename, extension = GetFileDetails(path)

	local contents, size = love.filesystem.read(include_path .. filename .. "." .. extension)
	if contents then
		local chunk, err = loadstring(contents)
		
		if not chunk then
			print("runtime error: '" .. path .. "' " .. err)
		else
			setfenv(chunk, getfenv(2))
			
			local success, err = pcall(chunk)
			if not success then
				print("runtime error: '" .. path .. "' - " .. err)
			end
		end
	end

	include_path = include_pathTemp
end

function AddCSLuaFile(path)
	if path then
		local filename, extension 	= GetFileDetails(path)
		local folder 				= GetPath(path)
		local fullpath 				= include_path .. folder .. filename .. "." .. extension
		local contents, size 		= love.filesystem.read(fullpath)

		if contents then
			downloads.AddContentByType("scripts", fullpath, contents)
		end
	else
		--Add current file to list of files to be downloaded by client
	end
end

--include(GetProjectDirectory() .. "lua/includes/modules/net.lua")

require(string.gsub(GetProjectDirectory(), "/", ".") .. "lua.includes.modules.net")
require(string.gsub(GetProjectDirectory(), "/", ".") .. "lua.includes.modules.time")

function love.load()
    if SERVER then
        net.Init("*:25465", 32)
    else
        net.Init("*:25565", 1)
    end
    
    print("starting: " .. (SERVER and "server" or "client"))
end

function love.update()
     
end

function love.render()
    
end