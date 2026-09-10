local Class = require("libraries.class")
local State = require("classes.states.state")

local PlayerIdle = Class{__includes = State}

function PlayerIdle:init(player)
    self.player = player
end

function PlayerIdle:enter()
    self.player.animation = self.player.animations.idle
end

function  PlayerIdle:update(dt)
    self.player.animation:update(dt)

    if love.keyboard.isDown("up")
    or love.keyboard.isDown("down")
    or love.keyboard.isDown("left")
    or love.keyboard.isDown("right") then
        return "walking"
    end
end

function PlayerIdle:render()
    self.player.animation:render(self.player.x, self.player.y)
end

function PlayerIdle:exit()
end

return PlayerIdle