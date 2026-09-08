local Class = require("libraries.class")
-- ============== CLASE ===============
local Animation = Class()

-- =============== INICIALIZACION ==================

--- Genera una nueva animacion a partir de los parametros 
--- @param img string ruta al spritesheet
--- @param index number columna/fila donde comineza la animacion
---@param frames_count number cantidad de frames
---@param width number ancho de cada sprite
---@param height number alto de cada sprite
---@param speed number velocidad a la que se reproduce la animacion
---@param is_vertical boolean sentido de avance de las animaciones en el spritesheet
function Animation:init(img, index, frames_count, width, height, speed, is_vertical)

    self.width = width
    self.height = height
    self.origin_x = width / 2
    self.origin_y = height / 2
    self.spritesheet = love.graphics.newImage(img)
    self.iterator = 1
    self.speed = speed
    self.quads = {}
    self.is_active = true

    if is_vertical then
        -- (frames_count - 1) por claridad al calcular la cantidad de frames a cargar
        for i = 0, frames_count - 1, 1 do
           table.insert(self.quads,
        love.graphics.newQuad(self.width * index, self.height * i, self.width, self.height, 
        self.spritesheet)
        ) 
        end
    else
        for i = 0, frames_count -1, 1 do
          table.insert(self.quads,
        love.graphics.newQuad(self.width * i, self.height * index, self.width, self.height,
        self.spritesheet)
        )  
        end
    end
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