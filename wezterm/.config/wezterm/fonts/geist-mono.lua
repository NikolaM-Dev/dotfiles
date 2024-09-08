local f = require('fonts')

local font = f.get_font()

local M = {}

function M.setup_font(config)
	local SCALE = 1

	config.cell_width = 0.9
	config.font_size = 13

	config.font = font({ family = 'Geist Mono', scale = SCALE, weight = 'Regular' })

	config.font_rules = {
		{
			font = font({ family = 'Geist Mono', weight = 'Bold', style = 'Normal', scale = SCALE }),
			intensity = 'Bold',
			italic = false,
		},
		{
			font = font({ family = 'Maple Mono NF', scale = SCALE, style = 'Italic', weight = 'Regular' }),
			intensity = 'Bold',
			italic = true,
		},
		{
			font = font({ family = 'Maple Mono NF', weight = 'Light', style = 'Italic', scale = SCALE }),
			intensity = 'Half',
			italic = true,
		},
		{
			font = font({ family = 'Maple Mono NF', weight = 'Light', style = 'Italic', scale = SCALE }),
			intensity = 'Normal',
			italic = true,
		},
	}
end

return M
