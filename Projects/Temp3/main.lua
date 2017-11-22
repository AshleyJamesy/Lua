include("extensions/")
include("util/")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

--Order of Execution
--Reset

--Awake
--OnEnable
--Start

--FixedUpdate
--INTERNAL PHYSICS UPDATE
--OnTrigger
--OnCollision
--yield WaitForFixedUpdate

--Inputs

--Update
--yield null
--yield WaitForSeconds
--yield XXX
--yield StartCoroutine
--INTERNAL ANIMATION UPDATE
--LateUpdate

--OnWillRenderObject
--OnPreCull
--OnBecameVisible
--OnBecameInvisible
--OnPreRender
--OnRenderObject
--OnPostRender
--OnRenderImage

--OnDrawGizmos

--OnGUI

--yield WaitForEndOfFrame
--ApplicationPause

--OnDisable

--OnApplicationQuit

--OnDisable

--OnDestroy

--TODO:
--[[
	Fix Yielding Execution Order
]]

--[[
function moveHandle(x, y, w, h)
	local handle = UIButton(p)
	handle.rects.native.x = x
	handle.rects.native.y = y
	handle.rects.native.w = w
	handle.rects.native.h = h

	handle.OnPressEvent = handle.OnPressEvent + function(object, x, y, istouch) 
		if not object.__offset then
			object.__offset = Vector2(0,0)
		end

		object.__offset:Set(object.rects.global.x - x + object.rects.global.w * object.anchor.x, object.rects.global.y - y + object.rects.global.h * object.anchor.y)
		
		object:RePaint()
	end

	handle.OnDragEvent = handle.OnDragEvent + function(object, x, y, istouch) 
		object.parent.rects.native.x = x + object.__offset.x
		object.parent.rects.native.y = y + object.__offset.y

		object:RePaint()
	end

	handle.OnReleaseEvent = handle.OnReleaseEvent + function(object, x, y, istouch) 
		object.parent.rects.native.x = math.clamp(object.parent.rects.global.x, 0, object.root.rects.native.w - object.parent.rects.native.w)
		object.parent.rects.native.y = math.clamp(object.parent.rects.global.y, 0, object.root.rects.native.h - object.rects.native.h)

		object:RePaint()
	end

	handle.OnHoverEnterEvent = handle.OnHoverEnterEvent + function(object, x, y)
		local cursor = love.mouse.getSystemCursor("hand")
		love.mouse.setCursor(cursor)
	end

	handle.OnHoverExitEvent = handle.OnHoverExitEvent + function(object, x, y)
		local cursor = love.mouse.getSystemCursor("arrow")
		love.mouse.setCursor(cursor)
	end

	return handle
end

function sizeHandle(x, y, w, h)
	local handle = UIButton(p)
	handle.rects.native.x = x
	handle.rects.native.y = y
	handle.rects.native.w = w
	handle.rects.native.h = h

	handle.OnDragEvent = handle.OnDragEvent + function(object, x, y, istouch) 
		object.parent.rects.native.h 	= math.clamp(y - object.parent.rects.global.y, 10, math.huge)
		object.rects.native.y = object.parent.rects.native.h - object.rects.native.h

		object:RePaint()
	end

	handle.OnReleaseEvent = handle.OnHoverExitEvent + function(object, x, y)
		if not object.__drag then
			local cursor = love.mouse.getSystemCursor("arrow")
			love.mouse.setCursor(cursor)
		end
	end

	handle.OnHoverEnterEvent = handle.OnHoverEnterEvent + function(object, x, y)
		local cursor = love.mouse.getSystemCursor("sizens")
		love.mouse.setCursor(cursor)
	end

	handle.OnHoverExitEvent = handle.OnHoverExitEvent + function(object, x, y)
		if not object.__drag then
			local cursor = love.mouse.getSystemCursor("arrow")
			love.mouse.setCursor(cursor)
		end
	end

	return handle
end
]]

function love.load(args)
	hook.Call("Awake")
	hook.Call("OnEnable")
	hook.Call("OnLevelWasLoaded")
	
	hook.Call("Start")

	canvas = UICanvas()

	local input = UIInputField(canvas)
	input.rects.native:Set(100, 100, 100, 18)

	local button = UIButton(canvas)
	button.rects.native:Set(300, 300, 100, 30)

	button.OnPressEvent = button.OnPressEvent + function(object, x, y, istouch) 
		input:Clear()
	end

	canvas:RePaint()
end

function love.fixedUpdate(dt)
	hook.Call("FixedUpdate")
end

function love.update(dt)
	hook.Call("Update")
	
	WaitForSecondsRealtime:DoYields()

	hook.Call("LateUpdate")
end

function love.draw()
	hook.Call("OnPreCull")				--Called before the camera culls the scene. Culling determines which objects are visible to the camera. OnPreCull is called just before culling takes place.
	hook.Call("OnBecameVisible")		--Called when an object becomes visible/invisible to any camera.
	hook.Call("OnBecameInvisible")		--
	hook.Call("OnWillRenderObject")		--Called once for each camera if the object is visible.
	hook.Call("PreRender")				--Called before the camera starts rendering the scene.
	hook.Call("OnRenderObject")			--Called after all regular scene rendering is done.
	hook.Call("OnPostRender")			--Called after a camera finishes rendering the scene.
	hook.Call("OnRenderImage")			--Called after scene rendering is complete to allow post-processing of the image

	hook.Call("OnDrawGizmos")			--Used for drawing Gizmos in the scene view for visualisation purposes.
	hook.Call("OnGUI")					--Called multiple times per frame in response to GUI events. The Layout and Repaint events are processed first, followed by a Layout and keyboard/mouse event for each input event.

	canvas:RePaint()
	canvas:Render()

	love.graphics.print(love.timer.getFPS(), 0, 0, 0, 1, 1)
end

function love.directorydropped(path)
	hook.Call("DirectoryDropped", path)
end

function love.filedropped(file)
	hook.Call("FileDropped", file)
end

function love.focus(focus)
	if focus then
		hook.Call("WindowFocus")
	else
		hook.Call("WindowLostFocus")
	end
end

function love.resize(w, h)
	hook.Call("WindowResize", w, h)
end

function love.lowmemory()
	hook.Call("LowMemory")
end

function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	hook.Call("KeyReleased", key, scancode)
end

function love.mousefocus(focus)
	if focus then
		hook.Call("MouseFocus")
	else
		hook.Call("MouseLostFocus")
	end
end

function love.mousepressed(x, y, button, istouch)
	hook.Call("MousePressed", x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
	hook.Call("MouseMoved", x, y, dx, dy, istouch)
end

function love.mousereleased(x, y, button, istouch)
	hook.Call("MouseReleased", x, y, button, istouch)
end

function love.wheelmoved(x, y)
	hook.Call("MouseWheelMoved", x, y)
end

function love.textedited(text, start, length)
	hook.Call("TextEdited", text, start, length)
end

function love.textinput(char)
	hook.Call("TextInput", char)
end

function love.textedited(text, start, length)
	if length then
		hook.Call("TextEdited", text, start, length)
	end
end

function love.visible(visible)
	hook.Call("WindowVisible", visible)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	hook.Call("TouchPressed", id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end

function love.quit()
	hook.Call("Quit")
end