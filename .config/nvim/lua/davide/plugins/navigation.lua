return {
	{
		"jackMort/tide.nvim",
		config = function()
			require("tide").setup({
				-- optional configuration
				keys = {
					leader = ";", -- Leader key to prefix all Tide commands
					panel = ";", -- Open the panel (uses leader key as prefix)
					add_item = "a", -- Add a new item to the list (leader + 'a')
					delete = "d", -- Remove an item from the list (leader + 'd')
					clear_all = "D", -- Clear all items (leader + 'x')
					horizontal = "v", -- Split window horizontally (leader + '-')
					vertical = "x", -- Split window vertically (leader + '|')
				},
			})
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
