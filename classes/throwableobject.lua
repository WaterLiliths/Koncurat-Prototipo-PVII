-- =========== MODULOS/CLASES REQUERIDAS ===============
local Sound = require("classes.sound")

-- =============== CLASE =====================
local ThrowableObject = {} -- Lo creo como tabla local para protegerlo
ThrowableObject.__index = ThrowableObject

-- ============= INICIALIZACION ==============
function ThrowableObject:new(pos_x, pos_y)
    local throwable_object = setmetatable({}, ThrowableObject)

    throwable_object.x = pos_x
    throwable_object.y = pos_y
    throwable_object.width = 30
    throwable_object.height = 30

    throwable_object.sprite = love.graphics.newImage("assets/plant.png")

    throwable_object.break_sound = Sound:new("sound/object_breaking.mp3")

    throwable_object.is_destroyed = false

    return throwable_object
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