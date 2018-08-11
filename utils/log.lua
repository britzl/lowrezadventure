local logger = require "ludobits.m.logger"


local M = {}


local loggers = {}

function M.set_enabled(enabled)
	local id = go.get_id()
	if enabled then
		loggers[id] = logger.create(tostring(id))
	else
		loggers[id] = nil
	end
end


return setmetatable(M, {
	__call = function(self, ...)
		local id = go.get_id()
		if loggers[id] then
			return loggers[id](...)
		end
	end
})