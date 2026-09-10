local Class = require("libraries.class")
local StateMachine = Class()

function StateMachine:init(states)
    self.base = {
        render = function () end,
        update = function () end,
        enter = function () end,
        exit = function () end
    }

    self.states = states or {}
    self.current_state = self.base
end

function StateMachine:change_state(state_name, initial_parameters)
    assert(self.states[state_name])
    self.current_state:exit()
    self.current_state = self.states[state_name] ()
    self.current_state:enter(initial_parameters)
    
end

function StateMachine:update(dt)

    -- Chequea si la función devuelve un valor (string) para cambiar de estado
    local next_state = self.current_state:update(dt)

    if next_state then
        self:change_state(next_state)
    end
end

function StateMachine:render()
    self.current_state:render()
end

return StateMachine