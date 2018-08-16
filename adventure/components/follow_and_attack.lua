local log = require "utils.log"
local events = require "adventure.events"

local M = {}

function M.create(broadcast, attack_distance, target, speed)
	assert(broadcast, "You must provide a broadcast function")
	assert(attack_distance, "You must provide an attack distance")
	assert(target, "You must provide a target to follow")
	assert(speed, "You must provide a speed")

	local instance = {}

	local move_data = { speed = speed }
	
	function instance.update(dt)
		local target_pos = go.get_world_position(target)
		local my_pos = go.get_world_position()
		local direction = my_pos - target_pos
		if vmath.length(direction) <= attack_distance then
			broadcast(events.ATTACK, { direction = direction.x > 0 and -1 or 1 })
		elseif direction.x > 0 then
			sprite.set_hflip("#sprite", true)
			broadcast(events.MOVE_LEFT, move_data)
		elseif direction.x < 0 then
			sprite.set_hflip("#sprite", false)
			broadcast(events.MOVE_RIGHT, move_data)
		end
	end

	return instance
end


return M