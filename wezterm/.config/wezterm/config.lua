local wezterm = require('wezterm') --[[@as Wezterm]]

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

return config
