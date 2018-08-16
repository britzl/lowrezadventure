local log = require "utils.log"
local events = require "adventure.events"

local M = {}


function M.create(delay)
	local instance = {}

	function instance.on_event(event_id, data)
		if event_id == events.DEATH then
			log("dead")
			timer.delay(delay or 0, false, function()
				go.delete()
			end)
		end
	end

	return instance
end


return M