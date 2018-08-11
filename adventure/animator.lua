local M = {}


function M.create(sprite_url, animations, default_animation_id)
	assert(sprite_url, "You must provie a sprite url")
	assert(animations, "You must provide some animations")
	if default_animation_id then
		assert(animations[default_animation_id], ("Default animation id %s does not exist"):format(default_animation_id))
	end

	local instance = {}

	local current_animation = nil

	local animation_queue = {}

	local function play(animation_id, cb)
		current_animation = animation_id

		sprite.play_flipbook(sprite_url, animations[animation_id], function(self, message_id, message, sender)
			current_animation = nil
			if cb then cb() end
			if #animation_queue > 0 then
				local next_animation = table.remove(animation_queue)
				play(animations[next_animation.animation], next_animation.cb)
			elseif default_animation then
				sprite.play_flipbook(sprite_url, animations[default_animation])
			end
		end)
	end
	
	function instance.play(animation_id, cb)
		assert(animations[animation_id], ("Unknown animation id %s"):format(animation_id))
		if current_animation then
			return
		end
		play(animation_id, cb)
	end

	function instance.play_now(animation_id, cb)
		assert(animations[animation_id], ("Unknown animation id %s"):format(animation_id))
		play(animation_id, cb)
	end

	function instance.play_next(animation_id, cb)
		assert(animations[animation_id], ("Unknown animation id %s"):format(animation_id))
		if not current_animation then
			play(animation_id, cb)
		else
			table.insert(animation_queue, { animation_id = animation_id, cb = cb })
		end
	end


	return instance
end


return M