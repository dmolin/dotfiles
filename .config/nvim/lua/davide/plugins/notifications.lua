return {
	-- provide nice LSP notifications on the bottom right
	{
		"j-hui/fidget.nvim",
		depends = "folke/tokyonight.nvim",
		config = function()
			require("fidget").setup({
				progress = {
					display = {
						progress_style = "IncSearch",
						group_style = "FidgetTask",
						icon_style = "FidgetSpinner",
					},
				},
			})

			local function setup_highlights()
				local highlights = {
					{ "FidgetTitle", { fg = "#ff9e64", bold = true } },
					{ "FidgetTask", { fg = "#ffffff" } },
					{ "FidgetSpinner", { fg = "#1FF400" } },
				}

				for _, highlight in ipairs(highlights) do
					local group = highlight[1]
					local styles = highlight[2]
					vim.api.nvim_set_hl(0, group, styles)
				end
			end

			-- Define the highlight groups and autocommands here
			setup_highlights()

			-- re-apply the highlight groups when the colorscheme changes
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = setup_highlights,
			})
		end,
	},
}
