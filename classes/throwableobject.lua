-- =============== CLASE =====================

local ThrowableObject = {} -- Lo creo como tabla local para protegerlo
ThrowableObject.__index = ThrowableObject

-- ============= INICIALIZACION ==============

function ThrowableObject:new(pos_x, pos_y)
    local throwable_object = setmetatable({}, ThrowableObject)

    throwable_object.x = pos_x
    throwable_object.y = pos_y

    throwable_object.is_down = false

    return throwable_object
end

-- ============ LOGICA ==============

function ThrowableObject:throw()
    self.is_down = true
end

-- ============ DIBUJADO ==============

function ThrowableObject:draw()
    if not self.is_down then
        love.graphics.rectangle("fill", self.x -5, self.y -5, 10, 10)
    end
end

return ThrowableObject