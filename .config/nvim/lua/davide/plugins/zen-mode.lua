return {
	"folke/zen-mode.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		plugins = {
			gitsigns = true,
		},
		window = {
			width = 160,
		},
	},
	keys = {
		{
			"<leader><leader>",
			"<cmd>ZenMode<cr>",
			desc = "Toggle Zen Mode on buffer",
		},
	},
}
