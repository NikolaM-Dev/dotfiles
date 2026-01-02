local f = require('fonts')

local font = f.get_font()

local M = {}

function M.setup_font(config)
	local SCALE = 0.98
	local FAMILY = 'Maple Mono NF'

	config.cell_width = 0.9
	config.font_size = 13

	config.font = font({ family = FAMILY, scale = SCALE, style = 'Normal' })

	config.font_rules = {
		{
			font = font({ family = FAMILY, scale = SCALE, style = 'Normal', weight = 'Bold' }),
			intensity = 'Bold',
			italic = false,
		},
		{
			font = font({ family = FAMILY, scale = SCALE, style = 'Italic' }),
			intensity = 'Bold',
			italic = true,
		},
		{
			font = font({ family = FAMILY, scale = SCALE, style = 'Italic' }),
			intensity = 'Normal',
			italic = true,
		},
		{
			font = font({ family = FAMILY, scale = SCALE, style = 'Italic' }),
			intensity = 'Bold',
			italic = true,
		},
	}
end

return M
