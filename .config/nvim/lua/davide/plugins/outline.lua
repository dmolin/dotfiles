return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		{ "<leader>of", "<cmd>OutlineFocus<CR>", desc = "Focus on utline" },
	},
	opts = {
		-- Your setup opts here
		outline_window = {
			position = "left",
			width = 50,
			relative_width = false,
		},
	},
	--[[config = function()
		require("outline").setup({
			outline_window = {
				position = "left",
				width = 50,
				relative_width = false,
			},
		})
	end,--]]
}
