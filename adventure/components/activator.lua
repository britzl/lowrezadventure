local events = require "adventure.events"

local M = {}

local TRIGGER_RESPONSE = hash("trigger_response")

--- Generate an ACTIVATE event when a trigger is entered
function M.create(broadcast, group)
	assert(broadcast, "You must provide a broadcast function")
	assert(group, "You must provide a collision group")

	local instance = {}

	function instance.on_message(message_id, message, sender)
		if message_id == TRIGGER_RESPONSE then
			if message.own_group == group and message.enter then
				broadcast(events.ACTIVATE)
			end
		end
	end
	
	return instance
end


return M