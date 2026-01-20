local M = {}

M.colors = {
	bg = '#1b1b1b',
	fg = '#aeaeae',
	selection = '#636363',
	black = '#717171',
	red = '#bb7c72',
	green = '#6d956f',
	yellow = '#9f8a51',
	blue = '#758fc1',
	cyan = '#6196a0',
	magenta = '#a185b6',
	white = '#aeaeae',
}

M.palette = {
	background = M.colors.bg,
	foreground = M.colors.fg,

	cursor_bg = M.colors.fg,
	cursor_border = M.colors.fg,
	cursor_fg = M.colors.bg,

	selection_bg = M.colors.red,
	selection_fg = M.colors.bg,

	quick_select_label_bg = { Color = M.colors.yellow },
	quick_select_label_fg = { Color = M.colors.bg },
	quick_select_match_bg = { Color = M.colors.bg },
	quick_select_match_fg = { Color = M.colors.selection },

	copy_mode_active_highlight_bg = { Color = M.colors.cyan },
	copy_mode_active_highlight_fg = { Color = M.colors.fg },
	copy_mode_inactive_highlight_bg = { Color = M.colors.red },

	ansi = {
		M.colors.black,
		M.colors.red,
		M.colors.green,
		M.colors.yellow,
		M.colors.blue,
		M.colors.cyan,
		M.colors.magenta,
		M.colors.white,
	},
	brights = {
		M.colors.black,
		M.colors.red,
		M.colors.green,
		M.colors.yellow,
		M.colors.blue,
		M.colors.cyan,
		M.colors.magenta,
		M.colors.white,
	},
}

return M
