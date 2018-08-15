local log = require "utils.log"
local animator = require "utils.animator"


local M = {}

--- Play animation when an event is received
function M.create(sprite_url, animations)
	assert(sprite_url, "You must provide a sprite url")
	assert(animations, "You must provide some animations")

	local instance = {}
	
	instance.animator = animator.create(sprite_url, animations)

	function instance.on_event(event_id, data)
		if animations[event_id] then
			instance.animator.play_now(event_id)
		end
	end

	return instance
end


return M