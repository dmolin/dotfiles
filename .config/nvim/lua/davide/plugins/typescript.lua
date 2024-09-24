return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		setup = function()
			require("typescript-tools").setup({
				settings = {
					tsserver_file_preferences = {
						importModuleSpecifierPreference = "non-relative",
						quotePreference = "double",
					},
				},
			})
		end,
	},
}
