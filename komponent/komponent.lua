local M = {}

local function ensure_hash(v)
	return type(v) == "string" and hash(v) or v
end


function M.create()
	local instance = {}

	local current_group

	local groups = {}

	local modules = {}

	function instance.group(id, ...)
		assert(id, "You must provide a group id")
		id = ensure_hash(id)
		assert(not groups[id], "Group already exists")
		local group = {
			id = id,
			functions = {
				init = {},
				final = {},
				update = {},
				on_message = {},
				on_input = {},
				on_reload = {},
				on_event = {},
			}
		}
		groups[id] = group
		current_group = current_group or group
		instance.add_to_group(id, ...)

		return group
	end

	function instance.add_to_group(group_id, ...)
		assert(group_id, "You must provide a group id")
		local group = groups[group_id]
		assert(group, "Group doesn't exist")

		for _,module in pairs({...}) do
			modules[module] = true
			if module.init then table.insert(group.functions.init, module.init) end
			if module.final then table.insert(group.functions.final, module.final) end
			if module.update then table.insert(group.functions.update, module.update) end
			if module.on_message then table.insert(group.functions.on_message, module.on_message) end
			if module.on_input then table.insert(group.functions.on_input, module.on_input) end
			if module.on_reload then table.insert(group.functions.on_reload, module.on_reload) end
			if module.on_event then table.insert(group.functions.on_event, module.on_event) end
		end
	end

	function instance.remove_from_group(group_id, ...)
		assert(group_id, "You must provide a group id")
		local group = groups[group_id]
		assert(group, "Group doesn't exist")

		for _,module in pairs({...}) do
			modules[module] = nil
			if module.init then remove_function(group.functions.init, module.init) end
			if module.final then remove_function(group.functions.final, module.final) end
			if module.update then remove_function(group.functions.update, module.update) end
			if module.on_message then remove_function(group.functions.on_message, module.on_message) end
			if module.on_input then remove_function(group.functions.on_input, module.on_input) end
			if module.on_reload then remove_function(group.functions.on_reload, module.on_reload) end
			if module.on_event then remove_function(group.functions.on_event, module.on_event) end
		end
	end	


	function instance.change_group(group_id)
		assert(group_id, "You must provide a group id")
		local group = groups[group_id]
		assert(group, "Group doesn't exist")
		
		current_group = group
	end


	function instance.current_group()
		return current_group and current_group.id
	end

	local function invoke_functions(fns, ...)
		for _,fn in ipairs(fns) do
			local ok, err = pcall(fn, ...)
			if not ok then
				print(err)
			end
		end
	end

	local function invoke_all_once(name, ...)
		local invoked = {}
		for _,group in pairs(groups) do
			for _,fn in ipairs(group.functions[name]) do
				if not invoked[fn] then
					local ok, err = pcall(fn, ...)
					if not ok then
						print(err)
					end
					invoked[fn] = true
				end
			end
		end
	end

	function instance.init(...)
		invoke_all_once("init")
	end

	function instance.final(...)
		invoke_all_once("final")
	end

	function instance.update(dt, ...)
		invoke_functions(current_group.functions.update, dt, ...)
	end

	function instance.on_message(message_id, message, sender, ...)
		invoke_functions(current_group.functions.on_message, message_id, message, sender, ...)
	end

	function instance.on_input(action_id, action, ...)
		invoke_functions(current_group.functions.on_input, action_id, action, ...)
	end

	function instance.on_reload(...)
		invoke_functions(current_group.functions.on_reload, ...)
	end

	function instance.on_event(event_id, ...)
		invoke_functions(current_group.functions.on_event, event_id, ...)
	end


	return instance
end


return M