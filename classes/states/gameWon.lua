-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local GameWon = Class{__includes = State}

function GameWon:init(game)
    self.game = game
end

function GameWon:enter()
    
end

function GameWon:update(dt)
end

function GameWon:keypressed(key)
    if key == "r" then
        self.game:restart()
    end
end

function GameWon:render()
end

function GameWon:render_ui()
    love.graphics.print("HAS GANADO!", 125, 70)
    love.graphics.print("Conseguiste la quinta porción de comida de la mañana", 125, 90)
    love.graphics.print("Presiona R para reiniciar", 125, 110)
end

function GameWon:exit()
    
end

return GameWon