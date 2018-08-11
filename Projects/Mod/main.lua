BIT   = require("bit")
FFI   = require("ffi")
ENET  = require("enet")

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

function LoadLuaFile(path, subfolders)
	local files = {}
 
	local info = love.filesystem.getInfo(path)
	if info then
		if info.type == "directory" then
			local folders = love.filesystem.getDirectoryItems(path)

			--Loop Files First
			for k, v in pairs(folders) do
				local info = love.filesystem.getInfo(path .. v)
				if info then
					if info.type == "file" then
						files[path .. v] = LoadLuaFile(path .. v)
					end
				end
			end

			if subfolders then
				--Loop Folders
				for k, v in pairs(folders) do
					local info = love.filesystem.getInfo(path .. v)
					if info then
						if info.type == "directory" then
							for i, j in pairs(LoadLuaFile(path .. v .. "/", subfolders)) do
								files[i] = j
							end
						end
					end
				end
			end

			return files
		end
	else
		--print("error loading lua file: file/directory '" .. path .. "' does not exist")

		return files
	end

	local name, extension = GetFileDetails(path)

	if extension == "lua" then
		local contents, size = love.filesystem.read(path)
		if not contents then
			print("error: '" .. path .. "' " .. size)
		else
			local file =
			{
				directory 	= GetPath(path),
				fullname 	= path,
				name 		= name,
				extension 	= extension,
				filename 	= name .. "." .. extension,
				code 		= contents,
				size 		= size
			}

			files[path] = file

			return file
		end
	end
end

function Include(filename)
    local function run()
        if SERVER then
          
            local path = __PATH
            __PATH = GetPath(path .. filename)
            
            local _lua = LoadLuaFile(__PATH .. filename)
            local env = {
                AddCSLuaFile = AddCSLuaFile,
                print = print,
                Include = Include,
                SERVER = SERVER
            }
            
            Load(_lua, env)
            
            __PATH = path
        end
    end
    
    --setfenv(run, getfenv(2))
    
    --local status, err = pcall(run)
end

local __require_path = ""
local __require = require

function Load(luafile, env)
	env.__PARENT        = __PARENT or _G
	env.__FILENAME    		= luafile.filename
	env.__PATH 		      	= luafile.directory
	env.__require_path 	= __require_path
	
	env.require = function(filename)
		return __require(string.gsub(luafile.directory .. __require_path, '/', '.') .. filename)
	end

	local func, err = loadstring(luafile.code) 
	
	if not func then 
		return nil, err
	end
	
	setfenv(func, env)
	
	local status, err = pcall(func)
	
	if not status then
		print("error: '" .. luafile.directory .. "' " .. err)
		
		return nil, err
	end
	
	return env
end

ClientSideFiles = {}
function AddCSLuaFile(filename)
	if SERVER then
		local path = __PATH

		if ClientSideFiles[path .. (filename and filename or __FILENAME)] then
			return
		end

		local lua_csfile = LoadLuaFile(path .. (filename and filename or __FILENAME))
		__PATH = path
  
		ClientSideFiles[path .. (filename and filename or __FILENAME)] = lua_csfile
	end
end

function LoadAddon(path)
    local addon = {}
    addon.autorun_shared = LoadLuaFile(path .. "autorun/")
    addon.autorun_server = LoadLuaFile(path .. "autorun/server/")
    addon.autorun_client = LoadLuaFile(path .. "autorun/client/")
    addon.gamemode_server = LoadLuaFile(path .. "gamemode/init.lua")
    addon.gamemode_client = LoadLuaFile(path .. "gamemode/cl_init.lua")
    
    --TODO: load sprites and sounds
    return addon
end

function love.load(args)
    local addons = {}
    local folders = love.filesystem.getDirectoryItems(GetProjectDirectory() .. "addons/")
    for k, v in pairs(folders) do
        addons[v] = LoadAddon(GetProjectDirectory() .. "addons/" .. v .. "/")
    end
    
    for k, addon in pairs(addons) do
        for j, script in pairs(addon.autorun_shared) do
            if script then
                local env = {
                    AddCSLuaFile = AddCSLuaFile,
                    print = print,
                    Include = Include,
                    SERVER = SERVER
                }
                
                Load(script, env)
            end
        end
    end
end

function love.update()
    
end