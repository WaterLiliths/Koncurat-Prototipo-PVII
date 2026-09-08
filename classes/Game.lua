-- Clase encargada de manejar la lógica del juego
local Class = require("libraries.class")
local Player = require("classes.player")
local Owner = require("classes.owner")
local ThrowableObject = require("classes.throwableobject")

local Game = Class()

-- ============ INICIALIZACION ==================

function Game:init()

    self.player = Player(160, 90)
    self.owner = Owner(100, 200)

    self.throwable_objects = {}

    table.insert(self.throwable_objects, ThrowableObject(50, 70))
    table.insert(self.throwable_objects, ThrowableObject(200, 50))
    table.insert(self.throwable_objects, ThrowableObject(250, 120))
    table.insert(self.throwable_objects, ThrowableObject(300, 250))
    table.insert(self.throwable_objects, ThrowableObject(350, 100))
    table.insert(self.throwable_objects, ThrowableObject(20, 220))
    table.insert(self.throwable_objects, ThrowableObject(150, 260))
    table.insert(self.throwable_objects, ThrowableObject(50, 100))


    self.annoyment_min = 40
    self.tenderness_min = 60

    self.annoyment_max = 60
    self.tenderness_max = 80

    self.is_playing = true
    self.is_won = false
    self.is_game_over = false

end

-- ============ LOGICA ============

function Game:check_collision(a, b)
        return -- devuelve true si un objeto está "dentro" de otro
        a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

function Game:interact()

    if not self.player.interaction_requested then
        return
    end

    for _, object in ipairs(self.throwable_objects) do
        if self:check_collision(self.player, object) then
            object:throw()
            self.owner:change_annoyment(15)
            self.owner:change_tenderness(-10)
            break
        end
    end

    if self:check_collision(self.player, self.owner) then

        self.owner:change_tenderness(10)
        self.owner:change_annoyment(-5)
        self.player.meow_sound:play()
        
    end

    self.player.interaction_requested = false

end

function Game:remove_destroyed_objects()
    for i = #self.throwable_objects, 1, -1 do
        if self.throwable_objects[i].is_destroyed then
            table.remove(self.throwable_objects, i)
        end
    end
end

function Game:keypressed(key)

    if self.is_won or self.is_game_over then
        if key == "r" then
            self:restart()
        end
    end

    self.player:keypressed(key)
end

function Game:check_win_condition()

    local tenderness_meet =
        self.owner.tenderness >= self.tenderness_min and
        self.owner.tenderness <= self.tenderness_max

    local annoyment_meet =
        self.owner.annoyment >= self.annoyment_min and
        self.owner.annoyment <= self.annoyment_max

    return tenderness_meet and annoyment_meet

end

function Game:check_lose_condition ()
    
    return self.owner.annoyment >= 100 or
        self.owner.tenderness >= 100

end

function Game:win_game()
    if self:check_win_condition() then
        self.is_playing = false
        self.is_won = true
    end
end

function Game:lose_game()
    if self:check_lose_condition() then
        self.is_playing = false
        self.is_game_over = true
    end
end

-- ============ ACTUALIZACION =========

function Game:update (dt)

    if not self.is_playing then
        return
    end

    self.player:update(dt)
    self.owner:update(dt)

    self:interact()
    self:remove_destroyed_objects()

    self:win_game()
    self:lose_game()


end

function Game:restart()

    self.player = Player(160, 90)
    self.owner = Owner(100, 120)

    self.throwable_objects = {}

    table.insert(self.throwable_objects, ThrowableObject(50, 70))
    table.insert(self.throwable_objects, ThrowableObject(200, 50))
    table.insert(self.throwable_objects, ThrowableObject(250, 120))
    table.insert(self.throwable_objects, ThrowableObject(300, 250))
    table.insert(self.throwable_objects, ThrowableObject(350, 100))
    table.insert(self.throwable_objects, ThrowableObject(20, 220))
    table.insert(self.throwable_objects, ThrowableObject(150, 260))
    table.insert(self.throwable_objects, ThrowableObject(50, 100))


    self.is_playing = true
    self.is_won = false
    self.is_game_over = false

end

-- ============ DIBUJADO ============

function Game:draw ()

    if not self.is_playing then
        return
    end

    for _, object in ipairs(self.throwable_objects) do
        object:draw()
    end

    self.owner:draw()
    self.player:draw()

end

--- Dibuja barras para la ui que actualizan el valor
function Game:draw_bar(x, y, width, height, value, max_value, target_min, target_max)
    
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


function Game:draw_result()

    if self.is_won then

        love.graphics.print("HAS GANADO!", 125, 70)
        love.graphics.print("Conseguiste la quinta porción de comida de la mañana", 125, 90)
        love.graphics.print("Presiona R para reiniciar", 125, 110)

    elseif self.is_game_over then

        love.graphics.print("HAS PERDIDO", 125, 70)
        love.graphics.print("Presiona R para reiniciar", 125, 110)

        if self.owner.annoyment >= 100 then
            love.graphics.print("Que hartante! Tu dueña te ha encerrado en la habitación", 125, 90) 
        elseif self.owner.tenderness >= 100 then
            love.graphics.print("Exceso de ternura! Tu dueña te ha atrapado en un abrazo no solicitado", 125, 90)

        end



    end

end

function Game:draw_ui()

    -- Barras de ternura y agotamiento de la dueña
    if self.is_playing then
        love.graphics.print("Ternura", 10, 10)
        self:draw_bar(10, 30, 200, 15, self.owner.tenderness, 100,
            self.tenderness_min, self.tenderness_max)
        love.graphics.print("Hartazgo", 220, 10)
        self:draw_bar(220, 30, 200, 15, self.owner.annoyment, 100,
            self.annoyment_min, self. annoyment_max)
        
        love.graphics.print("Presiona las flechas para moverte/'E' para interactuar", 10, 50)
        love.graphics.print("Alcanza nos niveles de ternura y hartazgo necesarios para que tu dueña te de de comer, otra vez",
        10, 70)
    end

    self:draw_result()

end

return Game