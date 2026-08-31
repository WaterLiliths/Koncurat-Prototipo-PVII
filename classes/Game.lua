-- Clase encargada de manejar la lógica del juego

local Player = require("classes.player")
local Owner = require("classes.owner")
local ThrowableObject = require("classes.throwableobject")

local Game = {}
Game.__index = Game

-- ============ INICIALIZACION ==================

function Game:new()

    local game = setmetatable({}, Game)

    game.player = Player:new(160, 90)
    game.owner = Owner:new(100, 120)
    game.throwable_object = ThrowableObject:new(50, 70)
    
    game.annoyment_min = 40
    game.tenderness_min = 60

    game.annoyment_max = 60
    game.tenderness_max = 80

    game.is_playing = true
    game.is_won = false
    game.is_game_over = false

    return game
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

    if self:check_collision(self.player, self.throwable_object) then

        self.throwable_object:throw()
        self.owner:change_annoyment(15)
        self.owner:change_tenderness(-10)
        
    end

    if self:check_collision(self.player, self.owner) then

        self.owner:change_tenderness(10)
        self.owner:change_annoyment(-5)
        
    end

    self.player.interaction_requested = false

end

function Game:keypressed(key)
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

    self:win_game()
    self:lose_game()


end

-- ============ DIBUJADO ============

function Game:draw ()
    self.player:draw()
    self.owner:draw()
    self.throwable_object:draw()
end

--- Dibuja barras para la ui que actualizan el valor
function Game:draw_bar(x, y, width, height, value, max_value)
    
    if not self.is_playing then
        return
    end

    -- Fondo de la barra
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", x, y, width, height)

    -- Relleno de la barra
    local fill_width = width * (value / max_value)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x, y, fill_width, height)

    -- Vuelvo al blanco para que no altere el dibujado del resto del juego 
    love.graphics.setColor(1, 1, 1)


end

-- Dibula la UI
function Game:draw_ui()

    -- Barras de ternura y agotamiento de la dueña

    love.graphics.print("Ternura", 10, 10)
    self:draw_bar(10, 30, 200, 15, self.owner.tenderness, 100)
    love.graphics.print("Hartazgo", 220, 10)
    self:draw_bar(220, 30, 200, 15, self.owner.annoyment, 100)
end

return Game