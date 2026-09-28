-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local GameOver = Class{__includes = State}

function GameOver:init(game)
    self.game = game
end

function GameOver:enter()
    
end

function GameOver:update(dt)
end

function GameOver:keypressed(key)
    if key == "r" then
        self.game:restart()
    end
end

function GameOver:render()
    
end

function GameOver:render_ui()

    love.graphics.setFont(self.game.title_font)
    love.graphics.setColor(0.75, 0.25, 0.25)
    love.graphics.printf("HAS PERDIDO", 0, 70, love.graphics.getWidth(), "center")

    love.graphics.setFont(self.game.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("Presiona R para reiniciar", 0, 190, love.graphics.getWidth(), "center")

    if self.game.owner.annoyment >= 100 then
        love.graphics.printf("¡Qué hartante! Tu dueña te ha encerrado en la habitación", 0,
        150, love.graphics.getWidth(), "center") 
    elseif self.game.owner.tenderness >= 100 then
        love.graphics.printf("¡Exceso de ternura! Tu dueña te ha atrapado en un abrazo no solicitado", 0,
        150, love.graphics.getWidth(), "center")

    end
end

function GameOver:exit()
    
end

return GameOver