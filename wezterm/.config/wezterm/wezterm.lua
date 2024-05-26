local c = require('config')
local f = require('fonts.maple-mono-nf')

local config = c.get_config()

f.setup_font(config)

	font = font({ family = base_font_family, weight = 'Regular' }),
	font_size = 11,
	font_rules = {
		{
			italic = true,
			intensity = 'Normal',
			font = font({
				family = base_font_family,
				style = 'Italic',
			}),
		},
		{
			italic = true,
			intensity = 'Half',
			font = font({
				family = base_font_family,
				style = 'Italic',
				weight = 'Medium',
			}),
		},
		{
			italic = true,
			intensity = 'Bold',
			font = font({
				family = base_font_family,
				style = 'Italic',
				weight = 'Bold',
			}),
		},
	},

	enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,

	cursor_blink_rate = 530,

	window_background_opacity = 0.9,

	window_close_confirmation = 'NeverPrompt',

	warn_about_missing_glyphs = false,

	term = 'wezterm',
}

return config
