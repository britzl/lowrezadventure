local log = require "utils.log"
local animations = require "adventure.enemies.animations"

local M = {}


function M.create()
	local instance = {}

	local swooping = false

	function instance.update(dt)
		if swooping then
			return
		end
		local player_pos = go.get_world_position("player")
		local my_pos = go.get_world_position()
		local distance = my_pos - player_pos
		if math.abs(distance.x < 20) then
			swooping = true
			go.animate(".", "posiiton.y", go.PLAYBACK_ONCE_PINGPONG, player_pos, go.EASING_INOUTQUAD, 1, 0, function()
				swooping = false
			end)
		end
	end

	return instance
end


return M