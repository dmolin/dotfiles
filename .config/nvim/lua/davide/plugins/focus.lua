-- this is just used to make the focused window stand out more
return {
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
}
