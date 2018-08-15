local log = require "utils.log"
local animations = require "adventure.enemies.animations"

local M = {}



function M.create(move_left, move_right, target, speed)
	assert(move_left, "You must provide a move_left function")
	assert(move_right, "You must provide a move_right function")
	assert(target, "You must provide a target to follow")
	assert(speed, "You must provide a speed")

	local instance = {}

	local data = { speed = speed }
	
	function instance.update(dt)
		local player_pos = go.get_world_position(target)
		local my_pos = go.get_world_position()
		local distance = my_pos - player_pos
		if distance.x > 0 then
			sprite.set_hflip("#sprite", true)
			move_left(data)
		elseif distance.x < 0 then
			sprite.set_hflip("#sprite", false)
			move_right(data)
		end
	end

	return instance
end


return M