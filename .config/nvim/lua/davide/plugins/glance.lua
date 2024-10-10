return {
	-- inspect functions and variables definitions
	"dnlhc/glance.nvim",
	config = function()
		local glance = require("glance")
		local actions = glance.actions

		glance.setup({
			detached = function(winid)
				return vim.api.nvim_win_get_width(winid) < 140
			end,
			border = {
				enable = true,
			},
			mappings = {
				list = {
					["j"] = actions.next, -- Bring the cursor to the next item in the list
					["k"] = actions.previous, -- Bring the cursor to the previous item in the list
					["<Down>"] = actions.next,
					["<Up>"] = actions.previous,
					["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
					["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
					["<C-u>"] = actions.preview_scroll_win(5),
					["<C-d>"] = actions.preview_scroll_win(-5),
					["h"] = actions.jump_vsplit, -- open the selected entry in a new horizontal split
					["v"] = actions.jump_split, -- open the selected entry in a new vertical split
					["t"] = actions.jump_tab,
					["<CR>"] = actions.jump,
					["o"] = actions.jump,
					["l"] = actions.open_fold,
					["x"] = actions.close_fold,
					["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
					["q"] = actions.close,
					["Q"] = actions.close,
					["<Esc>"] = actions.close,
					["<C-q>"] = actions.quickfix,
					-- ['<Esc>'] = false -- disable a mapping
				},
				preview = {
					["Q"] = actions.close,
					["<Tab>"] = actions.next_location,
					["<S-Tab>"] = actions.previous_location,
					["<leader>l"] = actions.enter_win("list"), -- Focus list window
				},
			},
		})
		vim.keymap.set("n", "<leader>gt", "<cmd>Glance definitions<CR>", { desc = "Glance definitions" })
	end,
}
