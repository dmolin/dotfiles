return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"

		require("tokyonight").setup({
			style = "night",
			styles = {
				sidebars = "dark",
			},
			sidebars = { "qf", "help" },
			dim_inactive = false,
			on_colors = function(colors)
				colors.bg = bg
				colors.bg_dark = bg_dark
				colors.bg_float = bg_dark
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = bg_dark
				colors.bg_statusline = bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
				--colors.comment = "#627E97"
				colors.comment = "#748ea4"
			end,
			on_highlights = function(hl, c)
				hl.DiagnosticUnnecessary = {
					fg = c.comment,
				}
			end,
		})
		vim.cmd("colorscheme tokyonight")

		vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#F0626E" })
		vim.api.nvim_set_hl(0, "diffAdded", { fg = "#86C72C" })
	end,
}
