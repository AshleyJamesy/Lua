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

function Class.CallFunctionOnAll(method, ignore, ...)
	if SceneManager.active then
		SceneManager.active:CallFunctionOnAll(method, ignore, ...)
	end
end

function Class.CallFunctionOnType(method, type, ...)
	if SceneManager.active then
		SceneManager.active:CallFunctionOnType(method, type, ...)
	end
end

function Class.RunFunctionOnAll(method, ignore, ...)
	if SceneManager.active then
		SceneManager.active:RunFunctionOnAll(method, ignore, ...)
	end
end

function Class.RunFunctionOnType(method, type, ...)
	if SceneManager.active then
		SceneManager.active:RunFunctionOnType(method, type, ...)
	end
end

function Class.Update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt
	
	SceneManager.GetActiveScene().transform:Update()
	
	SceneManager.CallFunctionOnAll("Update", nil, dt)
	SceneManager.CallFunctionOnAll("LateUpdate", nil, dt)
end