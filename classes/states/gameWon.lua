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
    love.graphics.setFont(self.game.title_font)
    love.graphics.setColor(0.30, 0.65, 0.35)
    love.graphics.printf("¡HAS GANADO!", 0, 70, love.graphics.getWidth(), "center")
    
    love.graphics.setFont(self.game.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("Conseguiste la quinta porción de comida de la mañana", 0,
    150, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona R para reiniciar", 0,
    190, love.graphics.getWidth(), "center")
end

function GameWon:exit()
    
end

return GameWon