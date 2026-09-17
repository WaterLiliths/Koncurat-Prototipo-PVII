local Class = require("libraries.class")
-- =========== CLASE ===========
local Sound = Class()

-- =========== INICIALIZACION ==============
function Sound:init(path)

    self.source = love.audio.newSource(path, "static")

end

-- ================ ACTUALIZACION =============
function Sound:play()

    self.source:stop()
    self.source:play()

end

return Sound