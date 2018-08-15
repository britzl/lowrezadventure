local M = {}


local function ensure_hash(v)
	return type(v) == "string" and hash(v) or v
end


function M.create()
	local instance = {}

	local events = {}

	function instance.subscribe(id, fn)
		assert(id, "You must provide an id")
		assert(fn, "You must provide a function")
		id = ensure_hash(id)
		if not events[id] then
			events[id] = {}
		end
		events[id][fn] = true
	end

	function instance.unsubscribe(id, fn)
		assert(id, "You must provide an id")
		assert(fn, "You must provide a function")
		id = ensure_hash(id)
		assert(events[id], ("No event with id %s exists"):format(id))
		events[id][fn] = nil
	end
	
	function instance.trigger(id, ...)
		assert(id, "You must provide an id")
		id = ensure_hash(id)
		if not events[id] then
			return
		end
		for fn,_ in pairs(events[id]) do
			local ok, err = pcall(fn, ...)
			if not ok then
				print(err)
			end
		end
	end
	
	return instance
end


return M