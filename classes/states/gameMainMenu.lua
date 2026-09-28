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
    love.graphics.setFont(self.game.title_font)
    love.graphics.setColor(0.35, 0.65, 0.75)
    love.graphics.printf("GORDIGATO", 0, 150, love.graphics.getWidth(), "center")

    love.graphics.setFont(self.game.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("¡Consigue tu quinta ración de comida en la mañana!",
    0, 250, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para comenzar",
    0, 280, love.graphics.getWidth(), "center") 

end

function GameMainMenu:exit()
    
end

return GameMainMenu