local log = require "utils.log"
local events = require "adventure.events"

local M = {}


function M.create(duration, distance)
	assert(duration, "You must provide a pushback duration")
	assert(distance, "You must provide a pushback distance")
	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.DAMAGE then
			log("pushback")
			local to = go.get_position() + data.normal * distance
			go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, to, go.EASING_INQUAD, 0.15, 0)
		end
	end

	return instance
end


return M