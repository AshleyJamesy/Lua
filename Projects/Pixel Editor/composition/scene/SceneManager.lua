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

function Class.RunFunction(method, ignore, ...)
	if SceneManager.active then
		SceneManager.active:RunFunction(method, ignore, ...)
	end
end

function Class.Update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt
	
	SceneManager.GetActiveScene().transform:Update()
	
	SceneManager.RunFunction("Update", nil, dt)
	SceneManager.RunFunction("LateUpdate", nil, dt)
end