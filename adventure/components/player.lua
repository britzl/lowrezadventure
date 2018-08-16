local log = require "utils.log"
local input = require "in.state"
local input_mapper = require "in.mapper"
local events = require "adventure.events"
local monarch = require "monarch.monarch"

local LEFT = hash("left")
local RIGHT = hash("right")
local ATTACK = hash("attack")
local JUMP = hash("jump")
local DEBUG = hash("debug")

local TRIGGER_RESPONSE = hash("trigger_response")

local M = {}

local SPEED_GROUND = 60
local SPEED_AIR = 60
local SPEED_JUMP = 220


function M.create(broadcast)
	assert(broadcast, "You must provide a broadcast function")
		
	local instance = {}

	local attacking = false

	local jump_data = {
		speed = SPEED_JUMP,
		allow_double_jump = true,
		allow_wall_jump = true,
	}

	local move_data = {
		speed = SPEED_GROUND
	}

	local attack_data = {
		direction = 0
	}

	local function game_over(message)
		broadcast(events.GAME_OVER)
		input.clear()
		msg.post("hud", "disable")
		monarch.show(hash("game_over"), nil, { message = message })
	end
		
	function instance.init()
		-- acquire input and map input to actions
		input.acquire()
		input_mapper.bind(input_mapper.KEY_LEFT, LEFT)
		input_mapper.bind(input_mapper.KEY_RIGHT, RIGHT)
		input_mapper.bind(input_mapper.KEY_SPACE, JUMP)
		input_mapper.bind(input_mapper.KEY_X, ATTACK)
		input_mapper.bind(input_mapper.KEY_1, DEBUG)
	end

	function instance.update(dt)
		if not attacking then
			if input.is_pressed(LEFT) then
				attack_data.direction = -1
				broadcast(events.MOVE_LEFT, move_data)
				sprite.set_hflip("#sprite", true)
			elseif input.is_pressed(RIGHT) then
				attack_data.direction = 1
				broadcast(events.MOVE_RIGHT, move_data)
				sprite.set_hflip("#sprite", false)
			else
				broadcast(events.IDLE)
			end		
		end
	end

	function instance.on_input(action_id, action)
		action_id = input_mapper.on_input(action_id)
		input.on_input(action_id, action)
		if action_id == JUMP then
			if action.pressed then
				move_data.speed = SPEED_AIR
				broadcast(events.JUMP, jump_data)
			elseif action.released then
				broadcast(events.ABORT_JUMP)
			end
		elseif action_id == ATTACK then
			if action.pressed then
				attacking = true
				broadcast(events.ATTACK, attack_data)
			end
		elseif action_id == DEBUG and action.released then
			--self.platypus.toggle_debug()
			msg.post("@system:", "toggle_physics_debug")
		end
	end

	function instance.on_message(message_id, message, sender)
		if message_id == TRIGGER_RESPONSE then
			if message.other_group == hash("goal") then
				game_over("Yay!\nYou found\na way out!")
			end
		end
	end

	function instance.on_event(event_id, data)
		if event_id == events.GROUND_CONTACT then
			move_data.speed = SPEED_GROUND
		elseif event_id == events.ATTACK_DONE then
			attacking = false
		elseif event_id == events.DEATH then
			game_over("Oh no!\nBetter luck\nnext time!")
		elseif event_id == events.ALIVE then
			msg.post("hud", "update_lives", { lives = data.health })
		end
	end

	return instance
end


return M