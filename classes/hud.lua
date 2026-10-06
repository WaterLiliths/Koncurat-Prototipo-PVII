-- ============ REQUIERE ==================
local Class = require("libraries.class")

-- ============ CLASE ==================
local HUD = Class{}

-- ============ Inicialización ==================
function HUD:init(world, owner, tenderness_min, tenderness_max, annoyment_min, annoyment_max)
    self.world = world
    self.owner = owner

    self.tenderness_min = tenderness_min
    self.tenderness_max = tenderness_max
    self.annoyment_min = annoyment_min
    self.annoyment_max = annoyment_max

    self.title_font = love.graphics.newFont('assets/fonts/PixelGamer-Regular.otf', 60)
    self.main_font_titles = love.graphics.newFont('assets/fonts/JAi_____.TTF', 20)
    self.main_font = love.graphics.newFont('assets/fonts/JAi_____.TTF', 13)
end

function HUD:render_ui()
    love.graphics.setFont(self.main_font)

    love.graphics.setColor(0, 0, 0)
    
    love.graphics.print("Ternura", 10, 10)
    self:draw_bar(10, 30, 200, 15, self.owner.tenderness, 100,
            self.tenderness_min, self.tenderness_max)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Hartazgo", 220, 10)
    self:draw_bar(220, 30, 200, 15, self.owner.annoyment, 100,
            self.annoyment_min, self.annoyment_max)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Presiona las flechas para moverte/'E' para interactuar", 10, 50)
    love.graphics.print("Alcanza nos niveles de ternura y hartazgo necesarios para que tu dueña te de de comer, otra vez",
        10, 70)

    love.graphics.setColor(1.0, 1.0, 1.0)
    
end

function HUD:render_main_menu()
    love.graphics.setFont(self.title_font)
    love.graphics.setColor(0.35, 0.65, 0.75)
    love.graphics.printf("GORDIGATO", 0, 150, love.graphics.getWidth(), "center")

    love.graphics.setFont(self.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("¡Consigue tu quinta ración de comida en la mañana!",
    0, 250, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para comenzar",
    0, 280, love.graphics.getWidth(), "center") 
end

function HUD:render_game_won()
    love.graphics.setFont(self.title_font)
    love.graphics.setColor(0.30, 0.65, 0.35)
    love.graphics.printf("¡HAS GANADO!", 0, 70, love.graphics.getWidth(), "center")
    
    love.graphics.setFont(self.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("Conseguiste la quinta porción de comida de la mañana", 0,
    150, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona R para reiniciar", 0,
    190, love.graphics.getWidth(), "center")
end

function HUD:render_game_over()
    love.graphics.setFont(self.title_font)
    love.graphics.setColor(0.75, 0.25, 0.25)
    love.graphics.printf("HAS PERDIDO", 0, 70, love.graphics.getWidth(), "center")

    love.graphics.setFont(self.main_font_titles)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.printf("Presiona R para reiniciar", 0, 190, love.graphics.getWidth(), "center")

    if self.owner.annoyment >= 100 then
        love.graphics.printf("¡Qué hartante! Tu dueña te ha encerrado en la habitación", 0,
        150, love.graphics.getWidth(), "center") 
    elseif self.owner.tenderness >= 100 then
        love.graphics.printf("¡Exceso de ternura! Tu dueña te ha atrapado en un abrazo no solicitado", 0,
        150, love.graphics.getWidth(), "center")

    end
end

function HUD:draw_bar(x, y, width, height, value, max_value, target_min, target_max)
    
    -- Fondo de la barra
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", x, y, width, height)

    -- Rango a alcanzar para ganar
    local target_x = x + width * (target_min / max_value)
    local target_width = width * ((target_max - target_min) / max_value)

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", target_x, y, target_width, height)

    -- Estado actual de la barra
    local fill_width = width * (value / max_value)

    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle("fill", x, y, fill_width, height)

    love.graphics.setColor(1, 1, 1) -- Vuelvo al blanco para no alterar el resto del dibujado
end

function HUD:draw_debug()
    local items = self.world:getItems()
    
    for _, item in ipairs(items) do
        local x, y, width, height = self.world:getRect(item)
        love.graphics.rectangle("line", x, y, width, height)
    end
end

return HUD