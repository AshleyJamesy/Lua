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

class.Load()

include("source/")

function Call(method, ...)
    for batch_name, batch in pairs(Component.Components) do
        for k, v in pairs(batch) do
            if v[method] then
                v[method](v, ...)
            else
                break
            end
        end
    end
end

function love.load()
    Sprite("test")
    for i = 1, 1000 do
        local go = GameObject()
        go:AddComponent("SpriteRenderer").offset = Vector2(math.random() * 500 - 250, math.random() * 500 - 250)
    end
end

function love.fixedupdate(dt)
    Call("FixedUpdate", dt)
end

function love.update(dt)
    Timer.Update()
    Transform.Root:Update()
    
    Call("Update", dt)
end

function love.draw()
    Call("Render")
end

function love.keypressed(key, scancode, isrepeat)
    Call("KeyPressed", key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch)
    Call("MousePressed", x, y, button, istouch)
end