-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")

-- =============== CLASE =====================

local Owner = {} -- Lo creo como tabla local para protegerlo
Owner.__index = Owner

-- ============= INICIALIZACION ==============

function Owner:new(pos_x, pos_y)
    
    local owner = setmetatable({}, Owner)

    owner.x = pos_x
    owner.y = pos_y
    owner. speed = 50
    owner.radius = 10
    owner.width = 30
    owner.height = 30

    owner.annoyment = 0 --Barra de hartazgo
    owner.tenderness = 0 --Barra de ternura

    return owner    
end

-- ================ LOGICA ==============

--- cambia la barra de hartazgo
--- @param amount number valor para subir en hartazgo
function Owner:change_annoyment(amount)
    self.annoyment = self.annoyment + amount
end

--- cambia la barra de ternura
--- @param amount number valor a subir en ternura
function Owner:change_tenderness(amount)
    self.tenderness = self.tenderness + amount
end

-- ============= ACTUALIZACION ============

function Owner:update (dt)

    -- prototipo del movimiento de la dueña
    
    if self.x + self.radius >= SCREEN_WIDTH or
    self.x <= 0 then 
        self.speed = self.speed * -1
    end

    self.x = self.x + self.speed * dt

end

-- ============= DIBUJADO ============

function Owner:draw ()
    love.graphics.circle("fill", self.x, self.y, 10)
end

return Owner