-- Clase encargada de manejar la lógica del juego

-- ============ REQUIERE ==================
local Class = require("libraries.class")
local Player = require("classes.player")
local Owner = require("classes.owner")
local ThrowableObject = require("classes.throwableobject")
local sti = require("libraries.sti")

-- FSM requisitos
local StateMachine = require("classes.states.stateMachine")
local GameMainMenu = require("classes.states.gameMainMenu")
local GamePlaying = require("classes.states.gamePlaying")
local GameWon = require("classes.states.gameWon")
local GameOver = require("classes.states.gameOver")

-- ==================== CLASE =================

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

    self.map = nil
    self.map = sti("map/map_one.lua")

    self.annoyment_min = 40
    self.tenderness_min = 60

    self.annoyment_max = 60
    self.tenderness_max = 80

    self.GameStateMachine = StateMachine{
        ['main_menu'] = function () return GameMainMenu(self) end,
        ['playing'] = function () return GamePlaying(self) end,
        ['game_won'] = function () return GameWon(self) end,
        ['game_over'] = function () return GameOver(self) end
    }

    self.GameStateMachine:change_state("main_menu")

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
            self.player:set_interaction("throw")
            self.owner:change_annoyment(15)
            self.owner:change_tenderness(-10)
            break
        end
    end

    if self:check_collision(self.player, self.owner) then
        self.player:set_interaction("cute")
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

    self.GameStateMachine:keypressed(key)

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

-- ============ ACTUALIZACION =========

function Game:update (dt)

    self.GameStateMachine:update(dt)

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

    self.GameStateMachine:change_state("playing")

end

-- ============ DIBUJADO ============

function Game:draw ()

    self.GameStateMachine:render()
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

function Game:draw_ui()

    self.GameStateMachine:render_ui()

end

return Game