local log = require "utils.log"
local animations = require "adventure.enemies.animations"

local M = {}

function M.create(a, b)
	local instance = {}

	local checkpoints = { a, b}

	function instance.update(self, dt)
		if not self.awake or not self.enabled or self.attacking then
			return
		end
		local my_pos = go.get_world_position()
		local checkpoint = checkpoints[1]
		if vmath.length(my_pos - checkpoint) > 5 then
			if my_pos.x > checkpoint.x then
				sprite.set_hflip("#sprite", true)
				self.platypus.left(self.speed)
				self.animator.play(animations.WALK)
			else
				sprite.set_hflip("#sprite", false)
				self.platypus.right(self.speed)
				self.animator.play(animations.WALK)
			end
		else
			table.insert(checkpoints, table.remove(checkpoints, 1))
		end
	end

	return instance
end


return M