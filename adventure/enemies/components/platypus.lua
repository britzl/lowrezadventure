local log = require "utils.log"
local platypus = require "platypus.platypus"
local events = require "adventure.enemies.events"

local M = {}


function M.create(config)
	assert(config, "You must provide a platypus config")
	local instance = {}

	local p = platypus.create(config)

	function instance.update(dt)
		p.update(dt)
	end

	function instance.on_event(event_id, data)
		if event_id == events.MOVE_LEFT then
			p.left(data.speed)
		elseif event_id == events.MOVE_RIGHT then
			p.right(data.speed)
		end
	end

	function instance.on_message(message_id, message, sender)
		p.on_message(message_id, message)
	end
	
	return instance
end



return M