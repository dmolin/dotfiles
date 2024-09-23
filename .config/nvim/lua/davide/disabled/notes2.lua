return {
	{
		"nvim-telekasten/calendar-vim",
	},
	{
		"nvim-neorg/neorg",
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		config = function()
			require("neorg").setup({
				-- Tell Neorg what modules to load
				load = {
					["core.defaults"] = {}, -- Load all the default modules
					["core.concealer"] = {}, -- Allows for use of icons
					["core.qol.todo_items"] = {},
					["core.dirman"] = { -- Manage your directories with Neorg
						config = {
							workspaces = {
								notes = "~/cryptomator/misc/notes",
								todos = "~/cryptomator/misc/todos",
							},
						},
					},
				},
			})
		end,
	},
}
