local wezterm = require('wezterm')

local M = {}

local function font(opts)
	return wezterm.font_with_fallback({
		opts,
		{ family = 'Symbols Nerd Font Mono' },
		{ family = 'Apple Color Emoji' },
	})
end

function M.get_font()
	return font
end

return M
