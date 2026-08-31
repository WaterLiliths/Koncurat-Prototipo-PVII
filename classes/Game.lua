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

-- ============ ACTUALIZACION =========

function Game:update (dt)

    self.player:update(dt)
    self.owner:update(dt)

    self:interact()

end

-- ============ DIBUJADO ============

function Game:draw ()
    self.player:draw()
    self.owner:draw()
    self.throwable_object:draw()
end

--- Dibuja las barras de hartazgo/ternura de la dueña
function Game:draw_bar(x, y, width, height, value, max_value)

    love.graphics.rectangle("fill", x, y, width, height)

    local fill_width = width * (value / max_value)

    love.graphics.rectangle("fill", x, y, fill_width, height)

end

return Game