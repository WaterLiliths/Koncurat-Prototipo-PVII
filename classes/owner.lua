-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")

-- =============== CLASE =====================

local Owner = {} -- Lo creo como tabla local para protegerlo
Owner.__index = Owner

-- ============= INICIALIZACION ==============

-- Funcion especifica para cargar las animaciones de player
function Owner:load_animations()
    
    self.animations = {}

    -- Funcion local aprovechando los parametros que comparte el spritesheet de player
    local function create_animation(row, frames_count, speed) 
        return Animation:new("assets/cat_spritesheet.png", row, frames_count, 32, 32, speed, false)
    end

    self.animations.walk_right = Animation:new("assets/walk_Right_Down.png", 0, 8, 48, 64, 7, false)
    self.animations.walk_left = Animation:new("assets/walk_Left_Down.png", 0, 8, 48, 64, 7, false)
end

function Owner:new(pos_x, pos_y)
    
    local owner = setmetatable({}, Owner)

    owner.x = pos_x
    owner.y = pos_y
    owner. speed = 50
    owner.radius = 10
    owner.width = 30
    owner.height = 30

    owner:load_animations()

    owner.animation = owner.animations.walk_right

    owner.annoyment = 0 --Barra de hartazgo
    owner.tenderness = 0 --Barra de ternura

    return owner    
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