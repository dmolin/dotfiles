return {
	--[[
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      -- indent = { char = "┊" },
      indent = { char = " " },
      -- indent = { char = "│" },
    },
  }
  --]]
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true,
					-- animation related
					duration = 10,
					delay = 300,
				},
			})
		end,
	},
}
