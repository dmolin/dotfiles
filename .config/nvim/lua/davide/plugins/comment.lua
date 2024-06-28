return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import comment plugin safely
		local comment = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		-- enable comment
		comment.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})
		--[[
    Basic mappings
    These mappings are enabled by default. (config: mappings.basic)

    NORMAL mode
    `gcc` - Toggles the current line using linewise comment
    `gbc` - Toggles the current line using blockwise comment
    `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
    `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
    `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
    `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment
    VISUAL mode
    `gc` - Toggles the region using linewise comment
    `gb` - Toggles the region using blockwise comment

    Extra mappings
    These mappings are enabled by default. (config: mappings.extra)

    NORMAL mode
    `gco` - Insert comment to the next line and enters INSERT mode
    `gcO` - Insert comment to the previous line and enters INSERT mode
    `gcA` - Insert comment to end of the current line and enters INSERT mode
    --]]
	end,
}
