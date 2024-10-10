return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
		config = function()
			local border = {
				{ "🭽", "FloatBorder" },
				{ "▔", "FloatBorder" },
				{ "🭾", "FloatBorder" },
				{ "▕", "FloatBorder" },
				{ "🭿", "FloatBorder" },
				{ "▁", "FloatBorder" },
				{ "🭼", "FloatBorder" },
				{ "▏", "FloatBorder" },
			}

			require("typescript-tools").setup({
				handlers = {
					["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
					["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
				},
				settings = {
					tsserver_file_preferences = {
						importModuleSpecifierPreference = "non-relative",
						quotePreference = "double",
					},
				},
			})
		end,
	},
}
