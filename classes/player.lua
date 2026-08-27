local Player = {} -- Lo creo como tabla local para protegerlo
Player.__index = Player

-- ============= INICIALIZACION ==============
function Player:new(pos_x, pos_y)
    local object = setmetatable({}, Player)

    object.x = pos_x
    object.y = pos_y

    object.speed = 100
    object.radius = 20

    return object
end

-- ============== ACTUALIZACION ==============
function Player:update(dt)
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
    end
end

-- ============ DIBUJADO ==================
function Player:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Player