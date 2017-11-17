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
include("classes/CustomEditor")
include("classes/")
include("source/")

class.Load()

print(line_total)

local errors = {}
function Call(method, ...)
    for batch_name, batch in pairs(Component.Components) do
        for k, v in pairs(batch) do
            if v[method] then
                local s, e = pcall(v[method], v, ...)
                if not s and e then
                    if table.HasValue(errors, e) then
                    else
                        errors[#errors + 1] = e

                        print(e)
                    end
                end
            else
                break
            end
        end
    end
end

function CallOnComponent(name, method, ...)
    if Component.Components[name] then
        for k, v in pairs(Component.Components[name]) do
            if v[method] then
                if v.enabled == nil or v.enabled == true then
                    local s, e = pcall(v[method], v, ...)
                    if not s and e then
                        if table.HasValue(errors, e) then
                        else
                            errors[#errors + 1] = e

                            print(e)
                        end
                    end
                end
            else
                return
            end
        end
    end
end

function SendMessage(method, ignore, ...)
    local ignore_t = ignore or {}
    for name, batch in pairs(Component.Components) do
        if table.HasValue(ignore_t, name) then
        else
            --TODO: Sort
            --local class = class.GetClass(name)
            --if class.sort then
                --BUG: table.sort will move indexes with same sort parameters
                --table.sort(batch, class.sort)
            --end

            for _, component in pairs(batch) do
                if component[method] then
                    if component.enabled == nil or component.enabled == true then
                        component[method](component, ...)
                    end
                else
                    --break here since this component batch does not have the method we are looking for
                    break
                end
            end
        end
    end
end

function CallOnMonoBehaviours(method, ...)
    for batch_name, batch in pairs(Component.Components) do
        for k, v in pairs(batch) do
            if not v.IsMonoBehaviour then 
                break 
            end

            if v[method] then
                local s, e = pcall(v[method], v, ...)
                if not s and e then
                    if table.HasValue(errors, e) then
                    else
                        errors[#errors + 1] = e

                        print(e)
                    end
                end
            else
                break
            end
        end
    end
end

hook.Add("KeyPressed", "createObject", function(key, scancode, isrepeat)
    if key == "e" then
        local x, y = love.mouse.getPosition()
        local o = scene:Create(Camera.main:ToWorld(x, y))
        o.transform.scale:Set(4, 4)
        o:AddComponent("SpriteRenderer", "resources/sprites/hero.png")
        o:AddComponent("Player")
    end
end)

function love.load()
    scene = Scene()

    a = GameObject()
    a:AddComponent("Camera")
    a:GetComponent("Camera").canvas = Canvas()
    a:GetComponent("Camera").background:Set(255,0,0,255)

    local o = GameObject()
    o:AddComponent("Camera")

    for i = 1, 1 do
        hook.Call("KeyPressed", "e")
    end
end

function love.fixedupdate(dt)
    Call("FixedUpdate", dt)
end

function love.update(dt)
    Time.Update()
    Transform.Root:Update()

    SendMessage("Update", nil, dt)
    SendMessage("LateUpdate", nil, dt)
end

function love.draw()
    CallOnComponent("Camera", "Render")

    love.graphics.setColor(255, 255, 255, 255)
    if Camera.main then
        love.graphics.print(love.timer.getFPS())
    else
        love.graphics.printf("No Main Camera", 0, love.graphics.getHeight() * 0.5, love.graphics.getWidth(), "center")
    end

    love.graphics.draw(a:GetComponent("Camera").canvas.source, 0, 0, 0, 0.3, 0.3)
end

--EVENTS
function love.directorydropped(path)
    Call("OnDirectoryDropped", path)
    hook.Call("OnDirectoryDropped", path)
end

function love.filedropped(file)
    Call("OnFileDropped", file)
    hook.Call("OnFileDropped", file)
end

function love.focus(focus)
    if focus then
        Call("WindowFocus")
        hook.Call("WindowFocus")
    else

    end
end

function love.resize(w, h)
    Call("WindowResize", w, h)
    hook.Call("WindowResize", w, h)
end

function love.lowmemory()
    Call("LowMemory")
    hook.Call("LowMemory")
end

function love.keypressed(key, scancode, isrepeat)
    Call("KeyPressed", key, scancode, isrepeat)
    hook.Call("KeyPressed", key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Call("KeyReleased", key, scancode)
    hook.Call("KeyReleased", key, scancode)
end

function love.mousefocus(focus)
    if focus then
        Call("MouseFocus")
        hook.Call("MouseFocus")
    else

    end
end

function love.mousepressed(x, y, button, istouch)
    Call("MousePressed", x, y, button, istouch)
    hook.Call("MousePressed", x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
    Call("MouseMoved", x, y, dx, dy, istouch)
    hook.Call("MouseMoved", x, y, dx, dy, istouch)
end

function love.mousereleased(x, y, button, istouch)
    Call("MouseReleased", x, y, button, istouch)
    hook.Call("MouseReleased", x, y, button, istouch)
end

function love.wheelmoved(x, y)
    Call("MouseWheelMoved", x, y)
    hook.Call("MouseWheelMoved", x, y)
end

function love.textedited(text, start, length)
    Call("TextEdited", text, start, length)
    hook.Call("TextEdited", text, start, length)
end

function love.textinput(text)
    Call("TextInput", text)
    hook.Call("TextInput", text)
end

function love.visible(visible)
    Call("WindowVisible", visible)
    hook.Call("WindowVisible", visible)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    Call("TouchPressed", id, x, y, dx, dy, pressure)
    hook.Call("TouchPressed", id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    Call("TouchMoved", id, x, y, dx, dy, pressure)
    hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    Call("TouchReleased", id, x, y, dx, dy, pressure)
    hook.Call("TouchMoved", id, x, y, dx, dy, pressure)
end