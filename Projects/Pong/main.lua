project = "Pong"

include("table")
include("types")
include("class")
include("Vector2")
include("Vector4")
include("Player")
include("Ball")

Player1 = Player()
Player2 = Player()
MyBall = Ball()

MyBall.position = Vector2(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
MyBall.size = Vector2(love.graphics.getHeight() * 0.05, love.graphics.getHeight() * 0.05)
MyBall.colour = Vector4(255, 255, 255, 255)
table.insert(MyBall.players, Player1)
table.insert(MyBall.players, Player2)

Player1.position = Vector2(love.graphics.getWidth() * (1 - 0.15), love.graphics.getHeight() * 0.5)
Player1.size = Vector2(love.graphics.getHeight() * 0.05, love.graphics.getWidth() * 0.15)
Player1.colour.z = 255

Player2.position.x = love.graphics.getWidth() * 0.15
Player2.position.y = love.graphics.getHeight() * 0.5
Player2.size.x = love.graphics.getHeight() * 0.05
Player2.size.y = love.graphics.getWidth() * 0.15
Player2.colour.x = 255

function love.load()
    log = ""
end

function love.update(dt)
    MyBall:Update(dt)
end

function love.touchmoved(id, x, y)
    if x > love.graphics.getWidth() * 0.5 then
        if id == Player1.touch then
            Player1.position.y = y
        end
    else
        if id == Player2.touch then
            Player2.position.y = y
        end
    end
end

function love.touchreleased(id, x, y)
    if id == Player1.touch then
        Player1.touch = nil
    end
    
    if id == Player2.touch then
        Player2.touch = nil
    end
end

function love.touchpressed(id, x, y)
    if x > love.graphics.getWidth() * 0.5 then
        if Player1.touch == nil then
            Player1.touch = id
            Player1.y = y
        end
    else
        if Player2.touch == nil then
            Player2.touch = id
            Player2.y = y
        end
    end
end

function love.draw()
    love.graphics.print(log, 0,1000, math.rad(-90), 2, 2)
    Player1:Draw()
    Player2:Draw()
    MyBall:Draw()
end








