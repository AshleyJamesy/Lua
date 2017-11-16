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
                local s, e = pcall(v[method], v, ...)
                if not s and e then
                    if table.HasValue(errors, e) then
                    else
                        errors[#errors + 1] = e

                        print(e)
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
                    component[method](component, ...)
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

function love.load()
    cam = GameObject()
    cam:AddComponent("Camera").zoom:Set(0.3, 0.3)

    scene = Scene()
end

function love.fixedupdate(dt)
    Call("FixedUpdate", dt)
end

function love.update(dt)
    Time.Update()
    Transform.Root:Update()

    CallOnMonoBehaviours("Update", dt)
    CallOnMonoBehaviours("LateUpdate", dt)

    Hotfixing()
end

function love.draw()
    if Camera.main then
        Camera.main:Render()
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(love.timer.getFPS())
end

function love.keypressed(key, scancode, isrepeat)
    Call("KeyPressed", key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Call("KeyReleased", key, scancode)
end

function love.mousepressed(x, y, button, istouch)
    Call("MousePressed", x, y, button, istouch)

    local go = scene:Create(Camera.main:ToWorld(x, y))
    go:AddComponent("SpriteRenderer", "resources/sprites/hero.png")
    go:AddComponent("Player")
end

function love.wheelmoved(x, y)
    if Camera.main then
        Camera.main.zoom.x = Camera.main.zoom.x - y * 0.1
        Camera.main.zoom.y = Camera.main.zoom.y - y * 0.1
    end
end