-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")

-- =============== CLASE =====================

local Player = {} -- Lo creo como tabla local para protegerlo
Player.__index = Player

-- ============= INICIALIZACION ==============
function Player:new(pos_x, pos_y)
    local player = setmetatable({}, Player)

    player.x = pos_x
    player.y = pos_y

    player.speed = 100
    
    player.animation = Animation:new("assets/cat_spritesheet.png", 30, 3, 32, 32, 5, false)

    return player
end

-- ============== ACTUALIZACION ==============
function Player:update(dt)

    self.animation:update(dt)

    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
    end
end

-- ============ DIBUJADO ==================
function Player:draw()

    self.animation:render(self.x, self.y)
end

return Player