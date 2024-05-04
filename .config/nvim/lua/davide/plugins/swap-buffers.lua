return {
	"caenrique/swap-buffers.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<A-S-h>", "<cmd>lua require('swap-buffers').swap_buffers('h')<CR>", { silent = true })
		keymap.set("n", "<A-S-l>", "<cmd>lua require('swap-buffers').swap_buffers('l')<CR>", { silent = true })
		keymap.set("n", "<A-S-j>", "<cmd>lua require('swap-buffers').swap_buffers('j')<CR>", { silent = true })
		keymap.set("n", "<A-S-k>", "<cmd>lua require('swap-buffers').swap_buffers('k')<CR>", { silent = true })
	end,
}
