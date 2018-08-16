local log = require "utils.log"
local stately = require "stately.stately"


local M = {}


function M.transition(event, from, to)
	assert(event, "You must provide an event")
	assert(from, "You must provide a from state")
	assert(to, "You must provide a to state")
	return { event = event, from = from, to = to }
end


--- State machine component
-- Used to change active component group
function M.create(change_group, initial_state, transitions)
	assert(change_group, "You must provide a change group function")
	assert(initial_state, "You must provide an initial state")
	assert(transitions, "You must provide a list of transitions")
	local instance = {}

	local fsm = stately.create()

	local states = {}
	for _,transition in ipairs(transitions) do
		if not states[transition.from] then
			states[transition.from] = fsm.state(transition.from)
		end
		if not states[transition.to] then
			states[transition.to] = fsm.state(transition.to)
		end
		local event = transition.event
		local from = states[transition.from]
		local to = states[transition.to]
		fsm.transition(from, to, event)
	end

	assert(states[initial_state], "The initial state doesn't exist among the transitions")

	fsm.on_state_change(function(from, to)
		change_group(to)
		log("Changing state from", from, "to", to)
	end)

	function instance.init()
		fsm.start(states[initial_state])
	end

	function instance.on_event(event_id, data)
		fsm.handle_event(event_id)
	end

	return instance
end


return M