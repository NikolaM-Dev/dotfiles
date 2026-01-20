local M = {}

---@param config any
---@param theme 'dicom' | 'gruvbox_material'
function M.setup(config, theme)
	config.color_scheme = theme
	config.color_schemes = {
		[theme] = require('themes.' .. theme).palette,
	}
end

return M
