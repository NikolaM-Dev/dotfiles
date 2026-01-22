local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

function M.get_config()
	return config
end

return M
