-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local PlayerWalking = Class{__includes = State}

-- Filtra las reacciones de colision con Bump al definir con qué objeto se colisionó
local function filter(item, other)
    if other.type == "wall" or other.type == "furniture" then
        return "slide"
    end

    return "cross"
end

function PlayerWalking:init(player)
    self.player = player
end

function PlayerWalking:enter()
end

function  PlayerWalking:update(dt)
    self.player.moving = false

    local dx = 0
    local dy = 0

    if love.keyboard.isDown("right") then
        dx = 1
        self.player.animation = self.player.animations.walk_right
        self.player.moving = true
    end
    if love.keyboard.isDown("left") then
        dx = -1
        self.player.animation = self.player.animations.walk_left
        self.player.moving = true
    end
    if love.keyboard.isDown("up") then
        dy = -1
        self.player.animation = self.player.animations.walk_up
        self.player.moving = true
    end
    if love.keyboard.isDown("down") then
        dy = 1
        self.player.animation = self.player.animations.walk_down
        self.player.moving = true
    end

    local goal_x = self.player.hitbox_x + (dx * self.player.speed) * dt
    local goal_y = self.player.hitbox_y + (dy * self.player.speed) * dt

    local actual_x, actual_y, collisions = self.player.world:move(self.player,
    goal_x, goal_y, filter)

    for _, collision in ipairs(collisions) do
    print("COLISION:", collision.type, collision.other)
    end

    -- Actualza la posición de la hitbox
    self.player.hitbox_x = actual_x
    self.player.hitbox_y = actual_y

    -- Actualiza el centro del sprite
    self.player.x = actual_x + self.player.origin_x
    self.player.y = actual_y + self.player.origin_y

    self.player.animation:update(dt)

    if self.player.interaction then
        return "interacting", self.player.interaction
    end

    if not self.player.moving then
        return "idle"
    end
end

function PlayerWalking:render()
    self.player.animation:render(self.player.x, self.player.y)
end

function PlayerWalking:exit()
end

return PlayerWalking