module("addon", package.seeall)

ENT = {
	Base 			= "base_entity",
	ClassName 		= "", 		--comes from folder name
	Folder 			= "", 		--comes from the directory
	Spawnable 		= false, 	--Is it spawnable?
	Editable 		= false, 	--Is it editable?
	AdminOnly 		= false, 	--Is it admin spawnable/editable only?
	Author 			= "", 		--the author
	Contact 		= "", 		--author contact details
	Purpose 		= "", 		--what is this used for
	Instructions 	= "", 		--how is it used
	PrintName 		= "" 		--a better name than ie; base_entity
}

--[[
	addon/
	addon/lua/
	addon/lua/entities/
	addon/lua/entities/entities/my_entity/
	addon/lua/entities/weapons/my_weapon/
	addon/lua/autorun/
	addon/lua/autorun/server/
	addon/lua/autorun/client/
	addon/materials/
	addon/models/
	addon/sounds/
]]

function LoadAddon(path)
	local entities_path = path .. "lua/entities/entities/"
	local info = love.filesystem.getInfo(entities_path)
	if info and info.type == "directory" then
		local entities = love.filesystem.getDirectoryItems(entities_path)
		for k, v in pairs(entities) do
			LoadEntity(entities_path .. v .. "/")
		end
	end
end

function LoadEntity(path)
	local environment = 
	{
		ENT 			= setmetatable({}, ENT),
		include 		= include,
		AddCSLuaFile 	= AddCSLuaFile,
		console 		= console,
		net 			= net,
		print 			= print
	}
	
	LoadLuaFile(path .. "shared.lua", environment)
	
	if SERVER then
		LoadLuaFile(path .. "init.lua", environment)
	else
		LoadLuaFile(path .. "cl_init.lua", environment)
	end
end

function LoadAddons(path)
	local info = love.filesystem.getInfo(path)
	if info and info.type == "directory" then
		local entities = love.filesystem.getDirectoryItems(path)
		for k, v in pairs(entities) do
			local folder = love.filesystem.getInfo(path .. v .. "/")
			if folder and folder.type == "directory" then
				LoadAddon(path .. v .. "/")
			end
		end
	end
end