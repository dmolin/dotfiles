return {
	--[[ floating filename label on the top right of the buffer
	{
		"b0o/incline.nvim",
		config = function()
			require("incline").setup()
		end,
		-- Optional: Lazy load Incline
		event = "VeryLazy",
	},
  --]]
	-- nvim component library
	{
		"MunifTanjim/nui.nvim",
	},
	-- Virtual text context for neovim treesitter (on the end of each block/function)
	{
		"andersevenrud/nvim_context_vt",
	},
}
