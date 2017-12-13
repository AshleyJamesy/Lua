include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/containers/")
include("classes/Object")
include("classes/Component")
include("classes/Behaviour")
include("classes/MonoBehaviour")
include("classes/GameObject")
include("classes/")
include("source/")

class.Load()

function love.load()
    local array = ArrayType("Vector2")

    array:Push({x = 1, y = 1})
    array:Push({x = 2, y = 2})
    
    print(array:Get(2))
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.print(love.timer.getFPS(), 0, 0, 0, 1, 1)
end

function love.directorydropped(path)
    hook.Call("OnDirectoryDropped", path)
end

function love.filedropped(file)
    hook.Call("OnFileDropped", file)
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

function love.textinput(text)
    hook.Call("TextInput", text)
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