local log = require "utils.log"
local events = require "adventure.events"

local M = {}


function M.create(sprite_url, duration)
	assert(sprite_url, "You must provide a sprite url")
	assert(duration, "You must provide a blink duration")

	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.DAMAGE then
			log("damageblink")
			go.set(sprite_url, "tint.w", 10)
			timer.delay(duration or 0.25, false, function()
				go.set(sprite_url, "tint.w", 1)
			end)
		end
	end

	return instance
end


return M