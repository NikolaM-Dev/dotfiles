local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}

---@param config Config
function M.setup(config)
	local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
	smart_splits.apply_to_config(config, {
		direction_keys = {
			move = { 'h', 'j', 'k', 'l' },
			resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
		},
		modifiers = { move = 'CTRL', resize = 'ALT' },
		log_level = 'info',
	})
end

return M
