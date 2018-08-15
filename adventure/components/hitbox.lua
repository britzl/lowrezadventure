local log = require "utils.log"
local events = require "adventure.enemies.events"

local CONTACT_POINT_RESPONSE = hash("contact_point_response")
local GROUP_ATTACK = hash("attack")
local GROUP_DANGER = hash("danger")


local M = {}

function M.create(hit, death, hitbox_url)
	assert(hit, "You need to provide a hit trigger")
	assert(death, "You need to provide a death trigger")
	assert(hitbox_url, "You must provide a hitbox url")

	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.DAMAGE then
			log("hitbox damage")
			msg.post(hitbox_url, "disable")
			timer.delay(0.25, false, function()
				msg.post(hitbox_url, "enable")
			end)
		end
	end
	
	function instance.on_message(message_id, message, sender)
		if message_id == CONTACT_POINT_RESPONSE then
			if message.other_group == GROUP_ATTACK then
				hit({ amount = 1, normal = message.normal })
			elseif message.other_group == GROUP_DANGER then
				death()
			end
		end
	end
	
	return instance
end


return M