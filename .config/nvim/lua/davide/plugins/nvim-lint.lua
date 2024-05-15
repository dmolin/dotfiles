return {
	"mfussenegger/nvim-lint",
	opts = {
		-- other config
		linters = {
			eslint_d = {
				args = {
					"--no-warn-ignored", -- <-- this is the key argument
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
				},
			},
		},
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "eslint_d", "eslint" },
			typescript = { "eslint_d", "eslint" },
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	end,
}
