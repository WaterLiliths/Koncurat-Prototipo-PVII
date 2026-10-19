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
    self.game.hud:render_game_won()
end

function GameWon:exit()
    
end

return GameWon