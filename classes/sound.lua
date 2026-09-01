-- =========== CLASE ===========
local Sound = {}
Sound.__index = Sound

-- =========== INICIALIZACION ==============
function Sound:new(path)

    local sound = setmetatable({}, Sound)

    sound.source = love.audio.newSource(path, "static")

    return sound
end

-- ================ ACTUALIZACION =============
function Sound:play()

    self.source:stop()
    self.source:play()

end

return Sound