-- ============== CLASE ===============
local Animation = {}
Animation.__index = Animation

-- =============== INICIALIZACION ==================

--- Genera una nueva animacion a partir de los parametros 
--- @param img string ruta al spritesheet
--- @param index number columna/fila donde comineza la animacion
---@param frames_count number cantidad de frames
---@param width number ancho de cada sprite
---@param height number alto de cada sprite
---@param speed number velocidad a la que se reproduce la animacion
---@param is_vertical boolean sentido de avance de las animaciones en el spritesheet
function Animation:new(img, index, frames_count, width, height, speed, is_vertical)

    local animation = setmetatable({}, Animation)

    animation.width = width
    animation.height = height
    animation.origin_x = width / 2
    animation.origin_y = height / 2
    animation.spritesheet = love.graphics.newImage(img)
    animation.iterator = 1
    animation.speed = speed
    animation.quads = {}
    animation.is_active = true

    if is_vertical then
        -- (frames_count - 1) por claridad al calcular la cantidad de frames a cargar
        for i = 0, frames_count - 1, 1 do
           table.insert(animation.quads,
        love.graphics.newQuad(animation.width * index, animation.height * i, animation.width, animation.height, 
        animation.spritesheet)
        ) 
        end
    else
        for i = 0, frames_count -1, 1 do
          table.insert(animation.quads,
        love.graphics.newQuad(animation.width * i, animation.height * index, animation.width, animation.height,
        animation.spritesheet)
        )  
        end
    end

    return animation
end

-- ============== ACTUALIZACION =================

function Animation:update(dt)

    if not self.is_active then --condicion de corte
        return
    end

    self.iterator = self.iterator + (self.speed * dt)
    if self.iterator >= #self.quads + 1 then
        self.iterator = 1
    end
end

-- ================ DIBUJADO ===================

function Animation:render (x, y)
    local current_frame = math.floor(self.iterator) -- transforma el iterator a un entero
    
    love.graphics.draw(self.spritesheet,
        self.quads[current_frame],
        x, y, 0, 1, 1,
        self.origin_x, self.origin_y
        )
end

return Animation