return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				-- already mapped by vim
				--keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Go to definition"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				-- opts.desc = "Show LSP implementations"
				-- keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				-- see details for the errors in the current buffer
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				-- to see the error details for the error on the line
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				opts.desc = "Remove unused imports"
				keymap.set(
					"n",
					"<leader>ri",
					":lua vim.lsp.buf.code_action({apply = true, context = {only = {'source.removeUnusedImports.ts'}, diagnostics = {}}})<CR>",
					opts
				) -- mapping to remove unused imports
			end,
		})

		-- auto-remove unused imports when saving a file
		--[[
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.tsx", "*.ts" },
			callback = function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.removeUnusedImports.ts" },
						diagnostics = {},
					},
				})
			end,
		})
    --]]

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["ts_ls"] = function()
				local function remove_unused_imports()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.removeUnusedImports.ts" },
							diagnostics = {},
						},
					})
				end
				lspconfig["ts_ls"].setup({
					capabilities = capabilities,
					commands = {},
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
					settings = {
						tsserver = {
							formatting = {
								enabled = true,
								options = {
									tabSize = 2,
									indentSize = 2,
									insertSpaces = true,
									bracketSpacing = true,
									arrowParens = "always",
								},
							},
						},
					},
					init_options = {
						hostInfo = "neovim",
						preferences = {
							quotePreference = "double",
							importModuleSpecifierPreference = "non-relative",
							-- importModuleSpecifierPreference = "relative",
						},
					},
					handlers = {
						["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
							if result.diagnostics == nil then
								return
							end

							-- ignore some tsserver diagnostics
							local idx = 1
							while idx <= #result.diagnostics do
								local entry = result.diagnostics[idx]

								local formatter = require("format-ts-errors")[entry.code]
								entry.message = formatter and formatter(entry.message) or entry.message

								-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
								if entry.code == 80001 then
									-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
									table.remove(result.diagnostics, idx)
								else
									idx = idx + 1
								end
							end

							vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
						end,
					},
				})
			end,
			-- ["svelte"] = function()
			-- 	-- configure svelte server
			-- 	lspconfig["svelte"].setup({
			-- 		capabilities = capabilities,
			-- 		on_attach = function(client, bufnr)
			-- 			vim.api.nvim_create_autocmd("BufWritePost", {
			-- 				pattern = { "*.js", "*.ts" },
			-- 				callback = function(ctx)
			-- 					-- Here use ctx.match instead of ctx.file
			-- 					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			-- 				end,
			-- 			})
			-- 		end,
			-- 	})
			-- end,
			-- ["graphql"] = function()
			-- 	-- configure graphql language server
			-- 	lspconfig["graphql"].setup({
			-- 		capabilities = capabilities,
			-- 		filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			-- 	})
			-- end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			--[[
			["rust_analyzer"] = function()
				lspconfig["rust_analyzer"].setup({
					settings = {
						["rust-analyzer"] = {
							assist = {
								importMergeBehavior = "last",
							},
							cargo = {
								loadOutDirsFromCheck = true,
							},
							procMacro = {
								enable = true,
							},
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
						},
					},
					capabilities = capabilities,
					filetypes = {
						"rust",
						"rs",
					},
					root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
				})
			end,
      --]]
		})
	end,
}
