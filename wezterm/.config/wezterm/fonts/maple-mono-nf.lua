local f = require('fonts')

local font = f.get_font()

local M = {}

function M.setup_font(config)
	local SCALE = 0.98

	config.font_size = 13
	config.cell_width = 0.9

	config.font = font({
		family = 'Maple Mono NF',
		scale = SCALE,
		weight = 'Light',
	})

	config.font_rules = {
		{
			font = font({ family = 'Maple Mono NF', weight = 'Bold', style = 'Normal', scale = SCALE }),
			intensity = 'Bold',
			italic = false,
		},
		{
			font = font({ family = 'Maple Mono NF', scale = SCALE, style = 'Italic', weight = 'Regular' }),
			intensity = 'Bold',
			italic = true,
		},
		{
			font = font({ family = 'Maple Mono NF', weight = 'Regular', style = 'Italic', scale = SCALE }),
			intensity = 'Half',
			italic = true,
		},
		{
			font = font({ family = 'Maple Mono NF', style = 'Italic', scale = SCALE }),
			intensity = 'Normal',
			italic = true,
		},
	}
end

return M
