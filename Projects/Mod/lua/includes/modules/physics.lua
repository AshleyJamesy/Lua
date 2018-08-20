module("physics", package.seeall)

local thread
ch = love.thread.newChannel()

world = nil
function Init()
    world = love.physics.newWorld(0, 9)
    
    thread = love.thread.newThread([[
    	    world, ch = ...
    	    require("love.event")
    	    require("love.physics")
    	    
    	    function startTouch(a, b, c)
    	        love.event.push("StartTouch", a, b, c)
    	    end
    	    
    	    function endTouch(a, b, c)
    	        love.event.push("EndTouch", a, b, c)
    	    end
    	    
    	    world:setCallbacks(startTouch, endTouch, nil, nil)
    	    
    	    while true do
    	        local dt = ch:demand()
    	        world:update(dt)
    	        
    	        ch:supply(true)
    	    end
    ]])
    
    thread:start(world, ch)
end

objects = {}

function SetDT(value)
    ch:supply(value)
end

function AddBody(x, y, type)
    local id = #objects + 1
    local body = love.physics.newBody(world, 0, 0, type == 1 and "dynamic" or "static")
    
    local shape = love.physics.newCircleShape(10)
    local fixture = love.physics.newFixture(body, shape)
    
    body:setPosition(x, y)
    
    fixture:setUserData(id)
    
    objects[id] = body
    
    return body
end

function love.handlers.StartTouch(a, b, contact)
    print("touch start")
end

function love.handlers.EndTouch(a, b, contact)
    print("touch end")
end

function Render()
    for id, object in pairs(objects) do
        for k, fixture in pairs(object:getFixtureList()) do
            local shape = fixture:getShape()
            if shape:getType() == "circle" then
                local x, y = object:getWorldPoints(0,0)
                love.graphics.circle("line", x, y, shape:getRadius())
            end
        end
    end
end