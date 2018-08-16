local log = require "utils.log"
local events = require "adventure.events"

local CONTACT_POINT_RESPONSE = hash("contact_point_response")
local GROUP_ATTACK = hash("attack")
local GROUP_DANGER = hash("danger")


local M = {}

function M.create(broadcast, hitbox_url)
	assert(broadcast, "You need to provide a broadcast function")
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
				broadcast(events.HIT, { amount = 1, normal = message.normal })
			elseif message.other_group == GROUP_DANGER then
				broadcast(events.DEATH)
			end
		end
	end
	
	return instance
end


return M