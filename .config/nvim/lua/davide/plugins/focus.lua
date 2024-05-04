return {
	"nvim-focus/focus.nvim",
	config = function()
		require("focus").setup({
			autoresize = {
				enable = false,
			},
			ui = {
				number = true,
				signcolumn = true,
				cursorcolumn = false,
				winhighlight = true,
			},
		})
	end,
}
