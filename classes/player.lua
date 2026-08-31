-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")

-- =============== CLASE =====================

local Player = {} -- Lo creo como tabla local para protegerlo
Player.__index = Player

-- ============= INICIALIZACION ==============

-- Funcion especifica para cargar las animaciones de player
function Player:load_animations()
    
    self.animations = {}

    -- Funcion local aprovechando los parametros que comparte el spritesheet de player
    local function create_animation(row, frames_count, speed) 
        return Animation:new("assets/cat_spritesheet.png", row, frames_count, 32, 32, speed, false)
    end

    self.animations.idle = create_animation(29, 3, 5)
    self.animations.walk_down = create_animation(4, 4, 6)
    self.animations.walk_up = create_animation(5, 4, 6)
    self.animations.walk_right = create_animation(6, 8, 8)
    self.animations.walk_left = create_animation(7, 8, 8)
end

function Player:new(pos_x, pos_y)
    local player = setmetatable({}, Player)

    player.x = pos_x
    player.y = pos_y

    player.speed = 100

    player:load_animations()
    
    player.animation = player.animations.idle

    return player
end

-- ============== FUNCIONES =================

function Player:throw_objetc()
    
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