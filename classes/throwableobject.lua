-- =========== MODULOS/CLASES REQUERIDAS ===============
local Sound = require("classes.sound")
local Class = require("libraries.class")

-- =============== CLASE =====================
local ThrowableObject = Class() -- Lo creo como tabla local para protegerlo

-- ============= INICIALIZACION ==============
function ThrowableObject:init(pos_x, pos_y)
    self.x = pos_x
    self.y = pos_y

    self.width = 30
    self.height = 30

    self.origin_x = self.width / 2
    self.origin_y = self.height / 2

    self.hitbox_x = self.x - self.width / 2
    self.hitbox_y = self.y - self.height / 2

    self.sprite = love.graphics.newImage("assets/plant.png")

    self.break_sound = Sound("sound/object_breaking.mp3")

    self.is_destroyed = false

end

-- ============ LOGICA ==============

function ThrowableObject:throw()
    self.is_destroyed = true
    self.break_sound:play()
end

-- ============ DIBUJADO ==============

function ThrowableObject:draw()
   -- love.graphics.rectangle("fill", self.x -5, self.y -5, 10, 10)
    love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.origin_x, self.origin_y)
end

function ThrowableObject:draw_debug()

    love.graphics.setColor(0,1,0)
    love.graphics.circle("fill", self.x, self.y, 1)
    love.graphics.rectangle("line", self.hitbox_x, self.hitbox_y, self.width, self.height)
    love.graphics.setColor(1,1,1)

end


return ThrowableObject