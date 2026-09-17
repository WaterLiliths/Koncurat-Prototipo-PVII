-- ============= REQUERIMIENTOS ================
local Class = require("libraries.class")

-- =========== CLASE ================
local StateMachine = Class()

function StateMachine:init(states)
    self.base = {
        render = function () end,
        render_ui = function () end, --Para ser usada por game
        update = function () end,
        keypressed = function () end,
        enter = function () end,
        exit = function () end
    }

    self.states = states or {}
    self.current_state = self.base
end

function StateMachine:change_state(state_name, initial_parameters)
    assert(self.states[state_name])
    self.current_state:exit()
    self.current_state = self.states[state_name](initial_parameters)
    self.current_state:enter(initial_parameters)
    
end

function StateMachine:update(dt)

    -- Chequea si la función devuelve un valor (string) para cambiar de estado
    local next_state, parameters = self.current_state:update(dt)

    if next_state then
        self:change_state(next_state, parameters)
    end
end

-- Para gestionar cambios con teclas, al no utilizar la FSM de manera global desde main
function StateMachine:keypressed(key)
    if self.current_state.keypressed then
        local next_state, parameters = self.current_state:keypressed(key)

        if next_state then
            self:change_state(next_state, parameters)
        end
    end
end

function StateMachine:render()
    self.current_state:render()
end

function StateMachine:render_ui()
    self.current_state:render_ui()
end

return StateMachine