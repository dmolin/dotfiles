return {
	"levouh/tint.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("tint").setup({
			tint = -60,
		})
	end,
}
