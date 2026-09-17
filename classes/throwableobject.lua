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
    love.graphics.draw(self.sprite, self.x, self.y)
end

return ThrowableObject