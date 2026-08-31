local Player = require("classes.player")

local player
local canvas

function love.load ()
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(640, 360)
    player = Player:new(160, 90)
end

function love.update (dt)
    player:update(dt)
end

function love.draw ()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    player:draw()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end