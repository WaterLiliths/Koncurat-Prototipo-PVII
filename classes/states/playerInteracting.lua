-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local PlayerInteracting = Class{__includes = State}

function PlayerInteracting:init(player, interaction)
    self.player = player
    self.interaction = interaction --Para saber cual interaccion realizar
end

function PlayerInteracting:enter()
    self.player.animation = self.player.animations[self.interaction]
    self.player.animation:reset()
end

function PlayerInteracting:update(dt)
    self.player.animation:update(dt)

    if self.player.animation.is_finished then
        return "idle"
    end
    
end

function PlayerInteracting:render()
    self.player.animation:render(self.player.x, self.player.y)
end

function PlayerInteracting:exit()
    self.player.interaction = nil
end

return PlayerInteracting