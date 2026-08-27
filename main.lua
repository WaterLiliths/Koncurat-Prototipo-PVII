local Player = require("classes.player")

local player

function love.load ()
    player = Player:new(200, 200)
end

function love.update (dt)
    player:update(dt)
end

function love.draw ()
    player:draw()
end