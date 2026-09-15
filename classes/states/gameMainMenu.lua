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
    love.graphics.print("GORDIGATO", 125, 70)
    love.graphics.print("Consigue tu quinta ración de comida en la mañana!", 125, 110)
    love.graphics.print("Presiona ENTER para comenzar", 125, 140)

end

function GameMainMenu:exit()
    
end

return GameMainMenu