-- =========== MODULOS/CLASES REQUERIDAS ===============
local Animation = require("classes.animations")
local Class = require("libraries.class")
local Signal = require("libraries.signal")

-- =============== CLASE =====================

local Owner = Class() -- Lo creo como tabla local para protegerlo

-- ============= INICIALIZACION ==============

-- Funcion especifica para cargar las animaciones de player
function Owner:load_animations()
    
    self.animations = {}

    self.animations.walk_right = Animation("assets/walk_Right_Down.png", 0, 8, 48, 64, 7, false, true)
    self.animations.walk_left = Animation("assets/walk_Left_Down.png", 0, 8, 48, 64, 7, false, true)
end

function Owner:init(pos_x, pos_y, world)
    self.x = pos_x
    self.y = pos_y
    self.speed = 50
    self.radius = 10
    self.width = 30
    self.height = 30

    self.origin_x = self.width / 2
    self.origin_y = self.height / 2

    self.hitbox_x = self.x - self.width
    self.hitbox_y = self.y - self.height

    self.type = "owner"

    self.world = world

    self:load_animations()

    self.animation = self.animations.walk_right

    self.annoyment = 0 --Barra de hartazgo
    self.tenderness = 0 --Barra de ternura

    -- SEÑALES
    Signal.register("object_thrown", function ()
        self:on_object_thrown()
    end)
    Signal.register("cute_interaction", function ()
        self:on_cute_interaction()
    end)
    Signal.register("time_passed", function ()
        self:on_time_passed()
    end)

    self.world:add(self, self.hitbox_x, self.hitbox_y, self.width, self.height)

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

    Signal.emit("annoyment_changed", self.annoyment)
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

    Signal.emit("tenderness_changed", self.tenderness)
end

-- AL RECIBIR SEÑALES

function Owner:on_object_thrown()
    self:change_annoyment(15)
    self:change_tenderness(-10)
end

function Owner:on_cute_interaction()
    self:change_tenderness(10)
    self:change_annoyment(-5)
end

function Owner:on_time_passed()
    self:change_annoyment(-1)
    self:change_tenderness(-1)
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

    self.hitbox_x = self.x - self.origin_x
    self.hitbox_y = self.y - self.origin_y
    self.world:update(self, self.hitbox_x, self.hitbox_y, self.width, self.height)

    self.animation:update(dt)

end

function Owner:reset(pos_x, pos_y, world)
    self.world = world
    self.x = pos_x
    self.y = pos_y

    self.world:add(self, self.hitbox_x, self.hitbox_y, self.width, self.height)

    self.annoyment = 0
    self.tenderness = 0

    Signal.emit("annoyment_changed", self.annoyment)
    Signal.emit("tenderness_changed", self.tenderness)
end

-- ============= DIBUJADO ============

function Owner:draw ()
    self.animation:render(self.x, self.y)
end

function Owner:draw_debug()

    love.graphics.setColor(0,1,0)
    love.graphics.circle("fill", self.x, self.y, 1)
    love.graphics.rectangle("line", self.hitbox_x, self.hitbox_y, self.width, self.height)
    love.graphics.setColor(1,1,1)

end

return Owner