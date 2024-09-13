return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup()
			-- Disable original virtual text
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
	{
		"davidosomething/format-ts-errors.nvim",
	},
}
