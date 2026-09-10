-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")
local Sound = require("classes.sound")
local Class = require("libraries.class")
local StateMachine = require("classes.states.stateMachine")
local PlayerIdle = require("classes.states.playerIdle")
local PlayerWalking = require("classes.states.playerWalking")

-- =============== CLASE =====================

local Player = Class() -- Lo creo como tabla local para protegerlo

-- ============= INICIALIZACION ==============

-- Funcion especifica para cargar las animaciones de player
function Player:load_animations()
    
    self.animations = {}

    -- Funcion local aprovechando los parametros que comparte el spritesheet de player
    local function create_animation(row, frames_count, speed) 
        return Animation("assets/cat_spritesheet.png", row, frames_count, 32, 32, speed, false)
    end

    self.animations.idle = create_animation(29, 3, 5)
    self.animations.walk_down = create_animation(4, 4, 6)
    self.animations.walk_up = create_animation(5, 4, 6)
    self.animations.walk_right = create_animation(6, 8, 8)
    self.animations.walk_left = create_animation(7, 8, 8)
end

function Player:init(pos_x, pos_y)

    self.x = pos_x
    self.y = pos_y
    self.width = 32 -- alto del sprite
    self.height = 32 -- alto del sprite
    self.speed = 100
    self.moving = false

    self.interaction_requested = false

    self:load_animations()
    self.meow_sound = Sound("sound/cat_meowing.mp3") 

    self.PlayerStateMachine = StateMachine {
        ['idle'] = function () return PlayerIdle(self) end,
        ['walking'] = function () return PlayerWalking(self) end
    }

    self.PlayerStateMachine:change_state('idle')


end

-- ============== FUNCIONES =================

function Player:interact()

    self.interaction_requested = true

end

function Player:keypressed(key)
    if key == "e" then
        self:interact()
    end
end

-- ============== ACTUALIZACION ==============

function Player:update(dt) --Se va a refactorizar luego con Maquinas de Estado/otras funciones

self.PlayerStateMachine:update(dt)

end

-- ============ DIBUJADO ==================
function Player:draw()

    self.PlayerStateMachine:render()
end

return Player