local Player = require("classes.player")
local Owner = require("classes.owner")

-- ======= RESOLUCION =======
SCREEN_WIDTH = 400 -- Para ancho 800
SCREEN_HEIGHT = 300 -- Para alto 600
SCALE = 2

local player
local owner
local canvas

function love.load ()
    love.window.setMode(SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE)
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    player = Player:new(160, 90)
    owner = Owner:new(100, 120)
end

function love.update (dt)
    player:update(dt)
    owner:update(dt)
end

function love.draw ()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    player:draw()
    owner:draw()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
end