includes = {}

if not MOBILE then
	git = ""
else
	log = {}
	function print(o)
		table.insert(log, tostring(o))
	end
end

function GetProjectDirectory()
	return git 
end

--[[Returns filename and extenstion]]
function GetFileDetails(filename)
	local file 	= string.reverse(filename)
	local i 	= string.find(file, "%.")

	if i then
		return string.reverse(string.sub(file, i + 1)), string.reverse(string.sub(file, 1, i - 1))
	end

	return filename, ""
end

function include(file)
	if file:sub(#file,#file) == '/' then
		local folder = love.filesystem.getDirectoryItems(GetProjectDirectory() .. file)

		for k, v in pairs(folder) do
			local filename, extenstion = GetFileDetails(v)
			if 		extenstion == "lua" then
				include(GetProjectDirectory() .. file .. filename)
			elseif 	extenstion == "" then
				local full_path = GetProjectDirectory() .. file .. filename
				if love.filesystem.isDirectory(full_path) then
					include(full_path .. "/")
				end
			else
				local full_path = GetProjectDirectory() .. file .. filename .. "." .. extenstion
				if love.filesystem.isDirectory(full_path) then
					include(full_path .. "/")
				end
			end
		end

		return
	end
	
	local include_path	= string.gsub(GetProjectDirectory(), '/', '.')
	local file_path		= string.gsub(file, '/', '.')
	local full_path		= include_path .. file_path
	
	if includes[full_path] then
		return
	end
	
	includes[full_path] = true
	
	local file = require(full_path)
	
	return file
end

include("extensions/")
include("util/")
include("classes/class")
include("classes/")
include("source/")
class.Load()

Scene("main")

local sprite = Sprite("resources/sprites/hero.png")
local frame  = Sprite("resources/sprites/panel.png")
--[[
sprite:NewFrame(16,16,16,16)
sprite:NewFrame(32,16,16,16)
sprite:NewFrame(48,16,16,16)
sprite:NewFrame(64,16,16,16)
sprite:NewFrame(80,16,16,16)
sprite:NewFrame(96,16,16,16)
sprite:NewFrame(16,32,16,16)
sprite:NewFrame(32,32,16,16)
sprite:NewFrame(48,32,16,16)
sprite:NewFrame(64,32,16,16)
sprite:NewFrame(80,32,16,16)
sprite:NewFrame(96,32,16,16)
sprite:NewFrame(16,48,16,16)
sprite:NewFrame(32,48,16,16)
sprite:NewFrame(48,48,16,16)
sprite:NewFrame(64,48,16,16)
sprite:NewFrame(80,48,16,16)
sprite:NewFrame(96,48,16,16)
sprite:NewFrame(16,64,16,16)
sprite:NewFrame(32,64,16,16)
sprite:NewFrame(48,64,16,16)
sprite:NewFrame(64,64,16,16)
sprite:NewFrame(80,64,16,16)
sprite:NewFrame(96,64,16,16)
sprite:NewFrame(16,80,16,16)
sprite:NewFrame(32,80,16,16)
sprite:NewFrame(48,80,16,16)

sprite:NewAnimation("idle", Animation(1.0, true, { 1, 2, 3, 4 }))
sprite:NewAnimation("walk", Animation(12.0, true, { 7, 8, 9, 10, 11, 12 }))

sprite:SaveAsset()
]]

function love.load()
	myCamera = GameObject()
	myCamera:AddComponent("Camera")

	local myObject = GameObject()
	myObject:AddComponent("SpriteRenderer", sprite)
	myObject:AddComponent("Player")
	myObject.transform.scale:Set(5,5)

	myFrame = Frame(frame)
end

function love.update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Update", "Transform", nil, dt)
	end

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnAll("Update", { "Transform" }, nil, dt)
	end
end

function love.draw()
	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Render", "Camera")
	end

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnAll("PostRender")
	end 

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("Delta: " .. string.format("%.5f", Time.delta), 10, 25)

	if Camera.main then
		local s = "Culling:\n"
		for k, v in pairs(Camera.main.culling) do
			s = s .. "	" .. v .. "\n"
		end

		love.graphics.print(s, 10, 40)
	end

	myFrame:Render()
end