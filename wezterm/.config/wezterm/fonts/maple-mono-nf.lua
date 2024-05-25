local f = require('fonts')

local font = f.get_font()

local M = {}

function M.setup_font(config)
	local scale = 0.98

	config.font_size = 13
	config.cell_width = 0.9
	-- config.line_height = 1.2

	config.font = font({
		family = 'Maple Mono NF',
		scale = scale,
		weight = 'Light',
	})

	config.font_rules = {
		{
			intensity = 'Bold',
			italic = false,
			-- font = font({ family = 'JetBrainsMono Nerd Font', weight = 'Bold', style = 'Normal', scale = 0.98 }),
			font = font({
				family = 'Maple Mono NF',
				weight = 'Bold',
				style = 'Normal',
				scale = scale,
				-- scale = 0.98
			}),
		},
		{
			intensity = 'Bold',
			italic = true,
			font = font({
				family = 'Maple Mono NF',
				weight = 'Regular',
				style = 'Italic',
				-- scale = 0.98
				scale = scale,
			}),
		},
		{
			italic = true,
			intensity = 'Half',
			font = font({
				family = 'Maple Mono NF',
				weight = 'Regular',
				style = 'Italic',
				-- scale = 0.98
				scale = scale,
			}),
		},
		{
			italic = true,
			intensity = 'Normal',
			font = font({
				family = 'Maple Mono NF',
				style = 'Italic',
				-- scale = 0.98
				scale = scale,
			}),
		},
	}
end

return M
