return {
	-- this is just used to make the focused window stand out more
	--[[
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
  --]]
	-- dim the inactive buffer, so the focused one stands out more
	{
		"levouh/tint.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("tint").setup({
				highlight_ignore_patterns = { "WinSeparator", "NeoTree", "Status.*" },
				tint = -45, -- Darken colors, use a positive value to brighten
				saturation = 0.6, -- Saturation to preserve
			})
		end,
	},
	-- dim the inactive buffer, so the focused one stands out more
	{
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
