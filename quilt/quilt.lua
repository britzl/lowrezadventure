local log = require "utils.log"

local M = {}


function M.create()
	local instance = {}

	local modules = {}

	local functions = {
		init = {},
		final = {},
		update = {},
		on_message = {},
		on_input = {},
		on_reload = {},
		on_event = {},
	}

	local function remove_function(t, fn)
		for i,v in ipairs(t) do
			if v == fn then
				table.remove(t, i)
				break
			end
		end
	end
	
	function instance.add(...)
		for _,module in pairs({...}) do
			modules[module] = true
			if module.init then table.insert(functions.init, module.init) end
			if module.final then table.insert(functions.final, module.final) end
			if module.update then table.insert(functions.update, module.update) end
			if module.on_message then table.insert(functions.on_message, module.on_message) end
			if module.on_input then table.insert(functions.on_input, module.on_input) end
			if module.on_reload then table.insert(functions.on_reload, module.on_reload) end
			if module.on_event then table.insert(functions.on_event, module.on_event) end
		end
		return instance
	end

	function instance.remove(...)
		for _,module in pairs({...}) do
			modules[module] = nil
			if module.init then remove_function(functions.init, module.init) end
			if module.final then remove_function(functions.final, module.final) end
			if module.update then remove_function(functions.update, module.update) end
			if module.on_message then remove_function(functions.on_message, module.on_message) end
			if module.on_input then remove_function(functions.on_input, module.on_input) end
			if module.on_reload then remove_function(functions.on_reload, module.on_reload) end
			if module.on_event then remove_function(functions.on_event, module.on_event) end
		end
	end

	local function invoke_functions(fns, ...)
		for _,fn in ipairs(fns) do
			local ok, err = pcall(fn, ...)
			if not ok then
				print(err)
			end
		end
	end

	function instance.init(self, ...)
		invoke_functions(functions.init, ...)
	end

	function instance.final(self, ...)
		invoke_functions(functions.final, ...)
	end

	function instance.update(self, dt, ...)
		invoke_functions(functions.update, dt, ...)
	end

	function instance.on_message(self, message_id, message, sender, ...)
		invoke_functions(functions.on_message, message_id, message, sender, ...)
	end

	function instance.on_input(self, action_id, action, ...)
		invoke_functions(functions.on_input, action_id, action, ...)
	end

	function instance.on_reload(self, ...)
		invoke_functions(functions.on_reload, ...)
	end

	function instance.on_event(event_id, ...)
		invoke_functions(functions.on_event, event_id, ...)
	end
	
	return instance
end



return M