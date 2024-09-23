return {
	-- this is just used to make the focused window stand out more
	{
		"nvim-focus/focus.nvim",
		config = function()
			require("focus").setup({
				autoresize = {
					enable = false,
				},
				ui = {
					-- number = true,
					absolutenumber_unfocussed = true,
					relativenumber = true,
					hybridnumber = true,
					signcolumn = false,
					cursorcolumn = false,
					winhighlight = true,
				},
			})
		end,
	},
	-- dim the inactive buffer, so the focused one stands out more
	{
		"levouh/tint.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("tint").setup({
				tint = -60,
			})
		end,
	},
}
