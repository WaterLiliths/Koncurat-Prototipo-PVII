-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")
local Sound = require("classes.sound")
local Class = require("libraries.class")

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

    self.interaction_requested = false

    self:load_animations()
    self.meow_sound = Sound("sound/cat_meowing.mp3") 
    
    self.animation = self.animations.idle


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

    local moving = false

    if love.keyboard.isDown("right") then
        self.animation = self.animations.walk_right
        self.x = self.x + self.speed * dt
        moving = true
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
        self.animation = self.animations.walk_left
        moving = true
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
        self.animation = self.animations.walk_up
        moving = true
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
        self.animation = self.animations.walk_down
        moving = true
    end

    if not moving then
        self.animation = self.animations.idle
    end
    self.animation:update(dt)

end

-- ============ DIBUJADO ==================
function Player:draw()

    self.animation:render(self.x, self.y)
end

return Player