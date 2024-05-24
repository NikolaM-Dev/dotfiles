local wezterm = require('wezterm')

local M = {}
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

function M.get_config()
	return config
end

return M
