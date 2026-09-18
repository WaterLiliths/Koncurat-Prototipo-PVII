-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")
local State = require("classes.states.state")

-- ========== CLASE =====================
local GamePlaying = Class{__includes = State}

function GamePlaying:init(game)
    self.game = game
    
    self.map_width = self.game.map.width * self.game.map.tilewidth
    self.map_height = self.game.map.height * self.game.map.tileheight
end

function GamePlaying:enter()
    
end

function GamePlaying:update(dt)
   
    self.game:interact()

    self.game.player:update(dt)

    self.game.main_camera:lookAt(self.game.player.x, self.game.player.y)

    -- Control de los límites de la cámara
    if self.game.main_camera.x < self.game.camera_center_x then
        self.game.main_camera.x = self.game.camera_center_x
    end

    if self.game.main_camera.y < self.game.camera_center_y then
        self.game.main_camera.y = self.game.camera_center_y
    end

    if self.game.main_camera.x > (self.map_width - self.game.camera_center_x) then
        self.game.main_camera.x = (self.map_width - self.game.camera_center_x)
    end

    if self.game.main_camera.y > (self.map_height - self.game.camera_center_y) then
        self.game.main_camera.y = (self.map_height - self.game.camera_center_y)
    end

    self.game.owner:update(dt)

    self.game:remove_destroyed_objects()

    if self.game:check_win_condition() then
        return "game_won"
    end
    
    if self.game:check_lose_condition() then
        return "game_over"
    end

end

function GamePlaying:render()

    self.game.main_camera:attach(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.game.map:drawLayer(self.game.map.layers["ground"])
    self.game.map:drawLayer(self.game.map.layers["grass"])
    self.game.map:drawLayer(self.game.map.layers["floor"])
    self.game.map:drawLayer(self.game.map.layers["walls"])
    self.game.map:drawLayer(self.game.map.layers["divisions"])
    
    for _, object in ipairs(self.game.throwable_objects) do
        object:draw()
    end

    self.game.owner:draw()
    self.game.player:draw()

    self.game:draw_debug()

    self.game.main_camera:detach()

    
end

function GamePlaying:render_ui()
    love.graphics.print("Ternura", 10, 10)
    self.game:draw_bar(10, 30, 200, 15, self.game.owner.tenderness, 100,
            self.game.tenderness_min, self.game.tenderness_max)
    love.graphics.print("Hartazgo", 220, 10)
    self.game:draw_bar(220, 30, 200, 15, self.game.owner.annoyment, 100,
            self.game.annoyment_min, self.game.annoyment_max)
        
    love.graphics.print("Presiona las flechas para moverte/'E' para interactuar", 10, 50)
    love.graphics.print("Alcanza nos niveles de ternura y hartazgo necesarios para que tu dueña te de de comer, otra vez",
        10, 70)
end

function GamePlaying:exit()
    
end

return GamePlaying