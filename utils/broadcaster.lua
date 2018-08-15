local log = require "utils.log"

local M = {}

local function ensure_hash(v)
	return type(v) == "string" and hash(v) or v
end


--- Create an event broadcaster
-- @return Broadcaster instance
function M.create()
	local broadcaster = {}

	local listeners = {}

	--- Create a trigger for an event
	-- A trigger is a simple object with a function to trigger
	-- the event
	-- @param event_id Event id to create trigger for
	-- @return Trigger instance
	function broadcaster.create_trigger(event_id)
		assert(event_id, "You must provide an event id")
		event_id = ensure_hash(event_id)
		local trigger = { id = event_id }

		function trigger.trigger(...)
			broadcaster.broadcast(event_id, ...)
		end

		return setmetatable(trigger, {
			__call = function(t, ...)
				broadcaster.broadcast(event_id, ...)
			end
		})
	end

	function broadcaster.create_triggers(event_ids)
		local triggers = {}
		for k,v in pairs(event_ids) do
			triggers[k] = broadcaster.create_trigger(v)
		end
		return triggers
	end

	--- Set a listener that will be notififed when events are triggered
	-- @param fn Function to invoke when an event is triggered
	function broadcaster.listen(fn)
		assert(fn, "You must provide a function")
		listeners[fn] = true
	end

	--- Remove a previously set listener
	-- @param fn The function to remove
	function broadcaster.unregister(fn)
		assert(fn, "You must provide a function")
		listeners[fn] = nil
	end

	--- Broadcast an event to all listeners
	-- The function will pass on any additional arguments to the listeners
	-- @param event_id
	function broadcaster.broadcast(event_id, ...)
		assert(event_id, "You must provide an event id")
		event_id = ensure_hash(event_id)
		for fn,_ in pairs(listeners) do
			local ok, err = pcall(fn, event_id, ...)
			if not ok then
				print(err)
			end
		end
	end

	return setmetatable(broadcaster, {
		__call = function(t, event_id, ...)
			return broadcaster.broadcast(event_id, ...)
		end
	})
end


return M