local Class = class.NewClass("EditorSceneManager", "SceneManager")
Class.scenes 			= 0
Class.sceneCount 		= 0
Class.activeScene 		= nil
Class.loadedSceneCount 	= {}

--Events
Class.activeSceneChanged 	= Delegate()
Class.sceneLoaded 			= Delegate()
Class.sceneUnLoaded 		= Delegate()
Class.newSceneCreated 		= Delegate()
Class.newSceneClosed 		= Delegate()
Class.newSceneClosing 		= Delegate()
Class.newSceneOpened 		= Delegate()
Class.newSceneSaved 		= Delegate()
Class.newSceneSaving 		= Delegate()

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