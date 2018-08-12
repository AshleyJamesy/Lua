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

--[[
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
]]

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

local require_path 	= ""
local require_old 	= require
function require(filename)
	print("requiring '" .. string.gsub(require_path, "/", ".") .. filename)
	return require_old(string.gsub(require_path, "/", ".") .. filename)
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
			print("runtime error: '" .. err .. "' " .. err)
		else
			setfenv(chunk, getfenv(2))
			
			local success, err = pcall(chunk)
			if not success then
				print("runtime error: " .. err)
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

function love.load()
	include("lua/includes/init.lua")

	local code = [[
		while true do
			io.flush()
			answer = io.read()
			io.write(answer .. "\n")
		end
	]]

	thread = love.thread.newThread(code)
	thread:start(0, 10)

	for k, v in pairs(io) do
		print(k, v)
	end
end

function love.update()

end

function love.draw()
	
end