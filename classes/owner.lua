-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")
local Class = require("libraries.class")

-- =============== CLASE =====================

local Owner = Class() -- Lo creo como tabla local para protegerlo

-- ============= INICIALIZACION ==============

-- Funcion especifica para cargar las animaciones de player
function Owner:load_animations()
    
    self.animations = {}

    self.animations.walk_right = Animation("assets/walk_Right_Down.png", 0, 8, 48, 64, 7, false)
    self.animations.walk_left = Animation("assets/walk_Left_Down.png", 0, 8, 48, 64, 7, false)
end

function Owner:init(pos_x, pos_y)
    self.x = pos_x
    self.y = pos_y
    self. speed = 50
    self.radius = 10
    self.width = 30
    self.height = 30

    self:load_animations()

    self.animation = self.animations.walk_right

    self.annoyment = 0 --Barra de hartazgo
    self.tenderness = 0 --Barra de ternura

end

-- ================ LOGICA ==============

--- cambia la barra de hartazgo
--- @param amount number valor para subir en hartazgo
function Owner:change_annoyment(amount)
    self.annoyment = self.annoyment + amount

    if self.annoyment <= 0 then
        self.annoyment = 0
    end

    if self.annoyment >= 100 then
        self.annoyment = 100
    end
end

--- cambia la barra de ternura
--- @param amount number valor a subir en ternura
function Owner:change_tenderness(amount)
    self.tenderness = self.tenderness + amount

    if self.tenderness <= 0 then
        self.tenderness = 0
    end

    if self.tenderness >= 100 then
        self.tenderness = 100
    end

end

-- ============= ACTUALIZACION ============

function Owner:update (dt)

    -- prototipo del movimiento de la dueña
    
    if self.x + self.radius >= SCREEN_WIDTH then
        self.speed = self.speed * -1
        self.animation = self.animations.walk_left
    end

    if self.x <= 0 then 
        self.speed = self.speed * -1
        self.animation = self.animations.walk_right
    end

    self.x = self.x + self.speed * dt

    self.animation:update(dt)

end

-- ============= DIBUJADO ============

function Owner:draw ()
    self.animation:render(self.x, self.y)
end

return Owner