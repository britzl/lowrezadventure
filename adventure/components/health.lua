local log = require "utils.log"
local events = require "adventure.events"

local M = {}


function M.create(broadcast, health)
	assert(broadcast, "You must provide a broadcast function")
	assert(health, "You must provide a health value")
	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.HIT then
			log("hit")
			health = health - data.amount
			if health <= 0 then
				broadcast(events.DEATH)
			else
				broadcast(events.DAMAGE, data)
				broadcast(events.ALIVE, { health = health })
			end
		end
	end

	return instance
end


return M