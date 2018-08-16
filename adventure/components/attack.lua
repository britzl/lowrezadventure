local log = require "utils.log"
local events = require "adventure.events"

local M = {}


function M.create(broadcast, attack_speed)
	assert(broadcast, "You must provide a broadcast function")
	assert(attack_speed, "You must provide an attack speed")
	
	local instance = {}

	local attacking = false

	function instance.init()
		msg.post("#attack_left", "disable")
		msg.post("#attack_right", "disable")
	end

	function instance.on_event(event_id, data)
		if event_id == events.ATTACK then
			if attacking then
				return
			end

			local attack_direction = (data.direction < 0) and "#attack_left" or "#attack_right"
			log("attack", attack_direction)
			attacking = true
			msg.post(attack_direction, "enable")
			timer.delay(attack_speed, false, function()
				attacking = false
				log("attack done")
				broadcast(events.ATTACK_DONE)
				msg.post(attack_direction, "disable")
			end)
		end
	end

	return instance
end


return M