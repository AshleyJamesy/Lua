module("physics", package.seeall)

local thread
local channel = love.thread.newChannel()

world = nil
function Init()
    love.physics.setMeter(10)
    world = love.physics.newWorld(0, 9.81 * 10, true)
    
    thread = love.thread.newThread([[
    	    world, channel = ...
    	    require("love.event")
    	    require("love.physics")
    	    
    	    function callback_StartTouch(a, b, c)
    	        love.event.push("StartTouch", a, b, c)
    	    end
    	    
    	    function callback_EndTouch(a, b, c)
    	        love.event.push("EndTouch", a, b, c)
    	    end
    	    
    	    --world:setCallbacks(callback_StartTouch, callback_EndTouch, nil, nil)
    	    
    	    while true do
    	        local dt = channel:demand()
    	        world:update(dt)
    	        
    	        channel:supply(true)
    	    end
    ]])
    
    thread:start(world, channel)
end

objects = {}

function Update(dt)
    channel:supply(dt)
end

function AddBody(x, y, type, str_shape, w, h)
    local id = #objects + 1
    local body = love.physics.newBody(world, 0, 0, type == 1 and "dynamic" or "static")
    
    local shape 
    if str_shape == "circle" then
        shape = love.physics.newCircleShape(w * 0.25)
    end

    if str_shape == "rectangle" then
        shape = love.physics.newRectangleShape(w, h)
    end

    local fixture = love.physics.newFixture(body, shape)

    body:setPosition(x, y)

    objects[id] = {
        class   = str_shape,
        body    = body
    }

    fixture:setUserData(objects[id])
    
    return body
end

function WaitForPhysicsUpdate()
    channel:demand()
end

function love.handlers.StartTouch(a, b, contact)

end

function love.handlers.EndTouch(a, b, contact)

end

function Render()
    for id, object in pairs(objects) do
        for k, fixture in pairs(object.body:getFixtures()) do
            local shape = fixture:getShape()
            if shape:getType() == "circle" then
                local x, y = object.body:getWorldPoints(0,0)
                love.graphics.circle("line", x, y, shape:getRadius())
            elseif shape:getType() == "polygon" then
                love.graphics.polygon("line", object.body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end