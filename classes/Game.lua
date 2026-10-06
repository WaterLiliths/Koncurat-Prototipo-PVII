-- Clase encargada de manejar la lógica del juego

-- ============ REQUIERE ==================
local Class = require("libraries.class")
local Player = require("classes.player")
local Owner = require("classes.owner")
local ThrowableObject = require("classes.throwableobject")
local HUD = require("classes.hud")
local STI = require("libraries.sti")
local Camera = require("libraries.camera")
local Bump = require("libraries.bump")

-- FSM requisitos
local StateMachine = require("classes.states.stateMachine")
local GameMainMenu = require("classes.states.gameMainMenu")
local GamePlaying = require("classes.states.gamePlaying")
local GameWon = require("classes.states.gameWon")
local GameOver = require("classes.states.gameOver")

-- ==================== CLASE =================

local Game = Class()

-- ============ INICIALIZACION ==================

function Game:init()  --Esta función y Game:restart() se refactorizarán luego para evtiar código duplicado

    -- MAPA
    self.map = STI("map/map_one.lua")

    -- MUNDO
    self.world = Bump.newWorld(32)

    if self.map.layers['wall_colisions'] then
        for _, object in ipairs(self.map.layers['wall_colisions'].objects) do
            object.type = "wall"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    if self.map.layers['doors_colisions'] then
        for _, object in ipairs(self.map.layers['doors_colisions'].objects) do
            object.type = "door"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    if self.map.layers['furniture_colisions'] then
        for _, object in ipairs(self.map.layers['furniture_colisions'].objects) do
            object.type = "furniture"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    self.player = Player(160, 590, self.world)
    self.owner = Owner(100, 600, self.world)

    self.throwable_objects = {}

    if self.map.layers['throwable'] then
        for _, spawn_point in ipairs(self.map.layers['throwable'].objects) do
            table.insert(self.throwable_objects,
            ThrowableObject(spawn_point.x, spawn_point.y, self.world))
        end
        
    end

    self.debug = false
   
    -- CAMARA
    self.camera_center_x = SCREEN_WIDTH * 0.5
    self.camera_center_y = SCREEN_HEIGHT * 0.5
    self.main_camera = Camera()

    self.annoyment_min = 40
    self.tenderness_min = 60

    self.annoyment_max = 60
    self.tenderness_max = 80


    self.hud = HUD(self.world, self.owner, self.tenderness_min, self.tenderness_max,
        self.annoyment_min, self.annoyment_max)


    self.GameStateMachine = StateMachine{
        ['main_menu'] = function () return GameMainMenu(self) end,
        ['playing'] = function () return GamePlaying(self) end,
        ['game_won'] = function () return GameWon(self) end,
        ['game_over'] = function () return GameOver(self) end
    }

    self.GameStateMachine:change_state("main_menu")

end

-- ============ LOGICA ============

--- Checkea si hay colision entre los objetos enviados por parametro
function Game:check_collision(a, b)
    local collisons = self.world:queryRect(a.hitbox_x, a.hitbox_y,
    a.width, a.height) --guarda las colisiones con a

    for _, item in ipairs(collisons) do
        if item == b then
            return true
        end
    end
end

function Game:interact()

    if not self.player.interaction_requested then
        return
    end

    local interacted = false

    for _, object in ipairs(self.throwable_objects) do
        if self:check_collision(self.player, object) then
            object:throw()
            self.player:set_interaction("throw")
            self.owner:change_annoyment(15)
            self.owner:change_tenderness(-10)

            interacted = true
            break
        end
    end

    if not interacted and self:check_collision(self.player, self.owner) then
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

    if key == "f1" then
        self.debug = not self.debug
    end

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

    self.world = Bump.newWorld(32)
    
    if self.map.layers['wall_colisions'] then
        for _, object in ipairs(self.map.layers['wall_colisions'].objects) do
            object.type = "wall"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    if self.map.layers['doors_colisions'] then
        for _, object in ipairs(self.map.layers['doors_colisions'].objects) do
            object.type = "door"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end

    if self.map.layers['furniture_colisions'] then
        for _, object in ipairs(self.map.layers['furniture_colisions'].objects) do
            object.type = "furniture"
            self.world:add(object, object.x, object.y, object.width, object.height)
        end
    end
    
    self.player = Player(160, 590, self.world)
    self.owner = Owner(100, 600, self.world)

    self.throwable_objects = {}

    if self.map.layers['throwable'] then
        for _, spawn_point in ipairs(self.map.layers['throwable'].objects) do
            table.insert(self.throwable_objects,
            ThrowableObject(spawn_point.x, spawn_point.y, self.world))
        end
        
    end

    self.debug = false

    self.GameStateMachine:change_state("playing")

end

-- ============ DIBUJADO ============

function Game:draw ()

    self.GameStateMachine:render()
end

function Game:draw_ui()

    self.GameStateMachine:render_ui()

end

function Game:draw_debug()

    if not self.debug then
        return
    end

    self.hud:draw_debug()
    
end

return Game