return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			direction = "horizontal",
			-- open_mapping = [[<c-\>]],
		})
		vim.keymap.set(
			"n",
			"<leader>tt",
			"<cmd>lua require('toggleterm').toggle()<cr>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set("n", "<C-\\>", ":ToggleTerm<cr>", { noremap = true, silent = true })
		vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<cr>", { noremap = true, silent = true })
		vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
	end,
}
