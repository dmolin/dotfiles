return {
	{
		"github/copilot.vim",
		event = { "BufReadPre", "BufNewFile" },
	},
	--[[
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
  --]]
}
