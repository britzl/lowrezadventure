local log = require "utils.log"

local M = {}

local function ensure_hash(v)
	return type(v) == "string" and hash(v) or v
end

function M.create()
	local broadcaster = {}

	local listeners = {}

	function broadcaster.create_trigger(id)
		assert(id, "You must provide an event id")
		id = ensure_hash(id)
		local trigger = { id = id }

		function trigger.trigger(...)
			broadcaster.on_event(id, ...)
		end

		return setmetatable(trigger, {
			__call = function(t, ...)
				broadcaster.on_event(id, ...)
			end
		})
	end

	function broadcaster.listen(fn)
		assert(fn, "You must provide a function")
		listeners[fn] = true
	end

	function broadcaster.unregister(fn)
		assert(fn, "You must provide a function")
		listeners[fn] = nil
	end

	function broadcaster.on_event(id, ...)
		assert(id, "You must provide an event id")
		id = ensure_hash(id)
		for fn,_ in pairs(listeners) do
			local ok, err = pcall(fn, id, ...)
			if not ok then
				print(err)
			end
		end
	end

	return setmetatable(broadcaster, {
		__call = function(t, ...)
			return broadcaster.on_event(id, ...)
		end
	})
end


return M