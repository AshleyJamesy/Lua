local Class = class.NewClass("Resources")
Class.Images = {}
Class.Sounds = {}

function Class:LoadImage(path)
	if Class.Images[path] then
		return Class.Images[path]
	end

	Class.Images[path] = love.graphics.newImage(GetProjectDirectory() .. path)
end

function Class:LoadSound(path)
	if Class.Sounds[path] then
		return Class.Sounds[path]
	end

	Class.Sounds[path] = love.audio.newSource(GetProjectDirectory() .. path)
end