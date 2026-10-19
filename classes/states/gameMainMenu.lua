-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local GameMainMenu = Class{__includes = State}

function GameMainMenu:init(game)
    self.game = game
end

function GameMainMenu:enter()
    
end

function GameMainMenu:update(dt)
end

function GameMainMenu:keypressed(key)
    if key == "return" then
        return "playing"
    end
end

function GameMainMenu:render()
    
end

function GameMainMenu:render_ui()
    self.game.hud:render_main_menu()
end

function GameMainMenu:exit()
    
end

return GameMainMenu