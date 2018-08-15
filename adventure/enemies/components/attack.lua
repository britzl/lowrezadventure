local log = require "utils.log"
local animations = require "adventure.enemies.animations"

local M = {}


function M.create(attack, attack_distance, attack_delay, attack_speed)
	local instance = {}

	local attacking = false

	function instance.update(dt)
		if attacking then
			return
		end
		local player_pos = go.get_world_position("player")
		local my_pos = go.get_world_position()
		local distance = my_pos - player_pos
		if vmath.length(distance) > attack_distance then
			return
		end
		local attack_direction = (distance.x > 0) and "#attack_left" or "#attack_right"
		log("attack")
		attacking = true
		timer.delay(attack_delay, false, function()
			msg.post(attack_direction, "enable")
			attack()
			timer.delay(attack_speed, false, function()
				attacking = false
				msg.post(attack_direction, "disable")
			end)
		end)
	end

	return instance
end


return M