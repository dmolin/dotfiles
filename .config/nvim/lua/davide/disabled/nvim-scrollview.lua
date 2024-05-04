return {
	"dstein64/nvim-scrollview",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local scrollview = require("scrollview")
		scrollview.setup({
			exclude_filetypes = { "nerdtree", "fugitive", "fugitiveblame" },
		})
	end,
}
