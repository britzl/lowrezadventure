local log = require "utils.log"
local platypus = require "platypus.platypus"
local events = require "adventure.events"

local M = {}

local GROUP_GROUND = hash("ground")

function M.create(broadcast, config)
	assert(broadcast, "You must provide a broadcast function")
	assert(config, "You must provide a platypus config")
	local instance = {}

	local p = platypus.create({
		collisions = {
			ground = { GROUP_GROUND },
			left = config.rays.left, right = config.rays.right, top = config.rays.top, bottom = config.rays.bottom,
		},
		gravity = -800,
		max_velocity = 600,
		separation = platypus.SEPARATION_SHAPES,
	})

	function instance.update(dt)
		p.update(dt)
	end

	function instance.on_event(event_id, data)
		if event_id == events.MOVE_LEFT then
			p.left(data.speed)
		elseif event_id == events.MOVE_RIGHT then
			p.right(data.speed)
		elseif event_id == events.JUMP then
			p.jump(data.speed, data.allow_double_jump, allow_wall_jump)
		elseif event_id == events.ABORT_JUMP then
			p.abort_jump()
		end
	end

	function instance.on_message(message_id, message, sender)
		p.on_message(message_id, message)
		if message_id == platypus.GROUND_CONTACT then
			broadcast(events.GROUND_CONTACT)
		elseif message_id == platypus.WALL_CONTACT then
			broadcast(events.WALL_CONTACT)
		elseif message_id == platypus.FALLING then
			broadcast(events.FALLING)
		end
	end
	
	return instance
end



return M