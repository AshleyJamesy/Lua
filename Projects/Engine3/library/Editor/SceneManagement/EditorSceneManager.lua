local Class = class.NewClass("EditorSceneManager", "SceneManager")
Class.scenes 			= 0
Class.sceneCount 		= 0
Class.activeScene 		= nil
Class.loadedSceneCount 	= {}

--Events
--[[
Class.activeSceneChanged 	= hook.CreateHookTable()
Class.sceneLoaded 			= hook.CreateHookTable()
Class.sceneUnLoaded 		= hook.CreateHookTable()
Class.newSceneCreated 		= hook.CreateHookTable()
Class.newSceneClosed 		= hook.CreateHookTable()
Class.newSceneClosing 		= hook.CreateHookTable()
Class.newSceneOpened 		= hook.CreateHookTable()
Class.newSceneSaved 		= hook.CreateHookTable()
Class.newSceneSaving 		= hook.CreateHookTable()
]]

NewSceneSetup = enum{
	"EmptyScene", 			--No game objects are added to the new scene.
	"DefaultGameObject",	--Adds default game objects to the new scene (a light and camera).
}

NewSceneMode = enum{
	"Single",
	"Additive"
}

function Class:NewScene(setup, newSceneMode)
	return Scene("scene")
end

function Class:OpenScene(path, openSceneMode)

end

function Class:MarkAllScenesDirty()
	for k, v in pairs(Class.scenes) do
		v.isDirty = true
	end
end

function Class:SaveOpenScenes(scene)

end

function Class:SaveScene(scene, path)

end

function Class:SaveScenes(scenes)

end