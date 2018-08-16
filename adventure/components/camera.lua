local camera = require "orthographic.camera"
local events = require "adventure.events"
local log = require "utils.log"


local M = {}


local CAMERA = hash("/camera")


local function lerp_with_dt(t, dt, v1, v2)
	return vmath.lerp(1 - math.pow(t, dt), v1, v2)
end


function M.create()
	local instance = {}

	local camera_offset
	local camera_offset_lerp
	
	function instance.init()
		-- center camera
		go.set_position(go.get_position(), CAMERA)

		camera_offset = vmath.vector3()
		camera_offset_lerp = vmath.vector3()
	end

	function instance.update(dt)
		camera_offset = lerp_with_dt(0.01, dt, camera_offset, camera_offset_lerp)
		camera.follow(CAMERA, go.get_id(), 0.001, camera_offset)
	end
	
	function instance.on_event(event_id, data)
		if event_id == events.MOVE_LEFT then
			camera_offset_lerp.x = -12
		elseif event_id == events.MOVE_RIGHT then
			camera_offset_lerp.x = 12
		elseif event_id == events.JUMP then
			camera_offset_lerp.y = 6
		elseif event_id == events.FALLING then
			camera_offset_lerp.y = -6
		elseif event_id == events.GROUND_CONTACT then
			camera_offset_lerp.y = 0
		end
	end
	

	return instance
end


return M