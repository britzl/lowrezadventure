local M = {}


function M.create(sprite_url, default_animation)
	local instance = {}

	local current_animation = nil

	local animation_queue = {}

	local function play(animation, cb)
		current_animation = animation

		sprite.play_flipbook(sprite_url, animation, function(self, message_id, message, sender)
			current_animation = nil
			if cb then cb() end
			if #animation_queue > 0 then
				local next_animation = table.remove(animation_queue)
				play(next_animation.animation, next_animation.cb)
			elseif default_animation then
				sprite.play_flipbook(sprite_url, default_animation)
			end
		end)
	end
	
	function instance.play(animation, cb)
		if current_animation then
			return
		end
		play(animation, cb)
	end

	function instance.play_now(animation, cb)
		play(animation, cb)
	end

	function instance.play_next(animation, cb)
		if not current_animation then
			play(animation, cb)
		else
			table.insert(animation_queue, { animation = animation, cb = cb })
		end
	end


	return instance
end


return M