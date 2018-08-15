local events = require "adventure.enemies.events"

local M = {}

local TRIGGER_RESPONSE = hash("trigger_response")

--- Trigger an activate function when a trigger is entered
function M.create(activate, group)
	assert(activate, "You must provide an activate trigger")
	assert(group, "You must provide a collision group")

	local instance = {}

	function instance.on_message(message_id, message, sender)
		if message_id == TRIGGER_RESPONSE then
			if message.own_group == group and message.enter then
				activate()
			end
		end
	end
	
	return instance
end


return M