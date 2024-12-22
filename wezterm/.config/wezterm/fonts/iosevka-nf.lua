local f = require('fonts')

local font = f.get_font()

local M = {}

function M.setup_font(config)
	local SCALE = 1

	config.cell_width = 1
	config.font_size = 13.5

	config.font = font({ family = 'Iosevka Nerd Font', scale = SCALE, style = 'Normal', weight = 'Regular' })

	config.font_rules = {
		{
			font = font({ family = 'Iosevka Nerd Font', weight = 'Bold', style = 'Normal', scale = SCALE }),
			intensity = 'Bold',
			italic = false,
		},
		{
			font = font({ family = 'Iosevka Nerd Font', scale = SCALE, style = 'Italic', weight = 'Regular' }),
			intensity = 'Bold',
			italic = true,
		},
		{
			font = font({ family = 'Iosevka Nerd Font', style = 'Italic', scale = SCALE }),
			intensity = 'Half',
			italic = true,
		},
		{
			font = font({ family = 'Iosevka Nerd Font', style = 'Italic', scale = SCALE }),
			intensity = 'Normal',
			italic = true,
		},
	}
end

return M
