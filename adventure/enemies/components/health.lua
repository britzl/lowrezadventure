local log = require "utils.log"
local events = require "adventure.enemies.events"

local M = {}


function M.create(die, damage, live, health)
	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.HIT then
			health = health - data.amount
			if health <= 0 then
				die()
			else
				damage(data)
				live()
			end
		end
	end

	return instance
end


return M