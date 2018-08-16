local events = require "adventure.events"
local log = require "utils.log"

local M = {}



function M.create(sounds)
	assert(sounds, "You must provide a list of sounds")
	
	local instance = {}

	function instance.on_event(event_id, data)
		if sounds[event_id] then
			msg.post("/sounds", "play", { id = sounds[event_id] })
		end
	end
	

	return instance
end

return M