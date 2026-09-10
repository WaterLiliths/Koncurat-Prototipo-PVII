local Class = require("libraries.class")
local State = require("classes.states.state")

local PlayerWalking = Class{__includes = State}

function PlayerWalking:init(player)
    self.player = player
end

function PlayerWalking:enter()
end

function  PlayerWalking:update(dt)
    self.player.moving = false

    if love.keyboard.isDown("right") then
        self.player.x = self.player.x + self.player.speed * dt
        self.player.animation = self.player.animations.walk_right
        self.player.moving = true
    end
    if love.keyboard.isDown("left") then
        self.player.x = self.player.x - self.player.speed * dt
        self.player.animation = self.player.animations.walk_left
        self.player.moving = true
    end
    if love.keyboard.isDown("up") then
        self.player.y = self.player.y - self.player.speed * dt
        self.player.animation = self.player.animations.walk_up
        self.player.moving = true
    end
    if love.keyboard.isDown("down") then
        self.player.y = self.player.y + self.player.speed * dt
        self.player.animation = self.player.animations.walk_down
        self.player.moving = true
    end

    self.player.animation:update(dt)

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