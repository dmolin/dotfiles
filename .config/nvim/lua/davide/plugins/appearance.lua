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
}
