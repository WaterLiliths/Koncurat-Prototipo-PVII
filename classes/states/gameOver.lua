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
    love.graphics.print("HAS PERDIDO", 125, 70)
    love.graphics.print("Presiona R para reiniciar", 125, 110)

    if self.game.owner.annoyment >= 100 then
        love.graphics.print("Que hartante! Tu dueña te ha encerrado en la habitación", 125, 90) 
    elseif self.game.owner.tenderness >= 100 then
        love.graphics.print("Exceso de ternura! Tu dueña te ha atrapado en un abrazo no solicitado", 125, 90)

    end
end

function GameOver:exit()
    
end

return GameOver