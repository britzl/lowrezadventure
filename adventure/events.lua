local M = {}

M.ACTIVATE = hash("activate")
M.ATTACK = hash("attack")
M.ATTACK_DONE = hash("attack_done")
M.HIT = hash("hit")
M.DEATH = hash("death")
M.ALIVE = hash("alive")
M.DAMAGE = hash("damage")
M.MOVE_LEFT = hash("move_left")
M.MOVE_RIGHT = hash("move_right")
M.JUMP = hash("jump")
M.ABORT_JUMP = hash("abort_jump")
M.GROUND_CONTACT = hash("ground_contact")
M.WALL_CONTACT = hash("wall_contact")
M.FALLING = hash("falling")

M.DEBUG = hash("debug")

return M