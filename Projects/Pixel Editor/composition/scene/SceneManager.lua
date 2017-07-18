include("class")
include("Time")
include("composition/scene/Scene")

local Class, BaseClass = class.NewClass("SceneManager")
SceneManager = Class
SceneManager.scenes = {}
SceneManager.active = nil

function Class.CreateScene(name)
	if SceneManager.scenes[name] then
		return SceneManager.scenes[name]
	end

	SceneManager.scenes[name] = Scene(name)

	if not SceneManager.active then
		SceneManager.active = SceneManager.scenes[name]
	end

	return SceneManager.scenes[name]
end

function Class.GetSceneByName(name)
	return SceneManager.scenes[name]
end

function Class.SetActiveScene(scene)
	SceneManager.active = scene
end

function Class.GetActiveScene()
	return SceneManager.active
end

function Class.RunFunction(func, type, ...)
	if SceneManager.active then
		if type ~= nil then
			if SceneManager.active.components[type] then
				for k, component in pairs(SceneManager.active.components[type]) do
					if component[func] then
						component[func](component, ...)
					else
						break
					end
				end
			end
		else
			for i, batch in pairs(SceneManager.active.components) do
				for k, component in pairs(batch) do
					if component[func] then

						component[func](component, ...)
					else
						break
					end
				end
			end
		end
	end
end

function Class.Update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt
	
	SceneManager.RunFunction("Update", "Transform", dt)
	SceneManager.RunFunction("Update", nil, dt)
end

