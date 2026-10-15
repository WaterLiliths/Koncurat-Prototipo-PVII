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
    self.game.hud:render_game_over()
end

function GameOver:exit()
    
end

return GameOver