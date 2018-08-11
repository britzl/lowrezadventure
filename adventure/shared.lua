local M = {}

function M.take_damage(self, message)
	self.enabled = false
	msg.post("#hitbox", "disable")
	local to = go.get_position() + message.normal * 10
	go.set("#sprite", "tint.w", 10)
	go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, to, go.EASING_INQUAD, 0.15, 0, function()
		msg.post("#hitbox", "enable")
		go.set("#sprite", "tint.w", 1)
		self.enabled = true
	end)
end

return M