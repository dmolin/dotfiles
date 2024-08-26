return {
	dir = "~/Development/nvim-plugins/missing-import.nvim",
	name = "missing-import",
	config = function()
		local module = require("missing-import")
		module.setup()
	end,
}
