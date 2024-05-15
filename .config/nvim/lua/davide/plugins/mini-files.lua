return {
	"echasnovski/mini.files",
	version = false,
	opts = {
		options = {
			use_as_default_explorer = false,
		},
	},
	config = function()
		local keymap = vim.keymap
		local files = require("mini.files")

		files.setup()

		keymap.set("n", "<leader>ee", function()
			local mf = require("mini.files")
			if not mf.close() then
				mf.open(vim.api.nvim_buf_get_name(0))
				mf.reveal_cwd()
			end
		end, { desc = "Toggle file explorer" })
	end,
}
