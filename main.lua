local Game = require("classes.Game")

-- ======= RESOLUCION =======
SCREEN_WIDTH = 400 -- Para ancho 800
SCREEN_HEIGHT = 300 -- Para alto 600
SCALE = 2

local game
local canvas

function love.load ()
    love.window.setMode(SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE)
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    game = Game:new()
end

function love.update (dt)
    game:update(dt)
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.draw ()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    game:draw()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
    game:draw_ui()
end