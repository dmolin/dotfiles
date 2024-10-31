local function normalize_path(path)
	return path:gsub("\\", "/")
end

local function normalize_cwd()
	return normalize_path(vim.loop.cwd()) .. "/"
end

local function is_subdirectory(cwd, path)
	return string.lower(path:sub(1, #cwd)) == string.lower(cwd)
end

local function split_filepath(path)
	local normalized_path = normalize_path(path)
	local normalized_cwd = normalize_cwd()
	local filename = normalized_path:match("[^/]+$")

	if is_subdirectory(normalized_cwd, normalized_path) then
		local stripped_path = normalized_path:sub(#normalized_cwd + 1, -(#filename + 1))
		return stripped_path, filename
	else
		local stripped_path = normalized_path:sub(1, -(#filename + 1))
		return stripped_path, filename
	end
end

local function path_display(_, path)
	local stripped_path, filename = split_filepath(path)
	if filename == stripped_path or stripped_path == "" then
		return filename
	end
	return string.format(" %s\t\t\t%s", filename, stripped_path)
end

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- path_display = { "smart" },
				-- path_display = { "filename_first" },
				file_ignore_patterns = { "node_modules", ".git", "^dist$", ".meteor" },
				path_display = path_display,
				mappings = {
					-- define mappings when in "i"nsert mode
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-h>"] = actions.select_vertical,
						["<C-v>"] = actions.select_horizontal,
					},
				},
			},
		})

		-- this will improve sorting performance
		telescope.load_extension("fzf")

		-- set keymaps
		local builtin = require("telescope.builtin")
		local utils = require("telescope.utils")
		local keymap = vim.keymap
		keymap.set("n", "<leader>fd", function()
			builtin.find_files({ cwd = utils.buffer_dir() })
		end, { desc = "Fuzzy find files in buffer cwd" })
		keymap.set(
			"n",
			"<leader>f.",
			builtin.current_buffer_fuzzy_find,
			{ desc = "Fuzzy find within the current buffer" }
		)
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in project" })
		-- keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in project" })
		keymap.set(
			"n",
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Find string under cursor in project" }
		)
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find Todos" })
		keymap.set("n", "<leader>fx", "<cmd>Telescope registers<cr>", { desc = "Find in Registers" })
		--keymap.set("n", "<leader>fo", "<cmd>Telescope buffers<cr>", { desc = "List opeb buffers" })

		-- buffers management
		local builtin = require("telescope.builtin")
		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")

		buffer_searcher = function()
			builtin.buffers({
				sort_mru = true,
				ignore_current_buffer = true,
				show_all_buffers = false,
				attach_mappings = function(prompt_bufnr, map)
					local refresh_buffer_searcher = function()
						actions.close(prompt_bufnr)
						vim.schedule(buffer_searcher)
					end

					local delete_buf = function()
						local selection = action_state.get_selected_entry()
						vim.api.nvim_buf_delete(selection.bufnr, { force = true })
						refresh_buffer_searcher()
					end

					local delete_multiple_buf = function()
						local picker = action_state.get_current_picker(prompt_bufnr)
						local selection = picker:get_multi_selection()
						for _, entry in ipairs(selection) do
							vim.api.nvim_buf_delete(entry.bufnr, { force = true })
						end
						refresh_buffer_searcher()
					end

					map("i", "<C-d>", delete_buf)
					map("n", "<C-D>", delete_multiple_buf)
					map("i", "<C-D>", delete_multiple_buf)

					return true
				end,
			})
		end

		keymap.set("n", "<leader>fo", buffer_searcher, {})
	end,
}
