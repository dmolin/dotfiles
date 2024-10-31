return {
	{
		"smartpde/telescope-recent-files",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("recent_files")

			vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>")
		end,
	},
}
