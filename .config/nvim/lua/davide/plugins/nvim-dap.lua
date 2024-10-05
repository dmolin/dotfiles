return {
	-- Debugger Adapter Protocol (used to trance and debug apps)
	{
		"mfussenegger/nvim-dap",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
			local dap = require("dap")
			local dapui = require("dapui")
			vim.keymap.set("n", "<leader>hb", ":DapToggleBreakpoint<CR>")
			vim.keymap.set("n", "<leader>hx", ":DapTerminate<CR>")
			vim.keymap.set("n", "<leader>ho", ":DapStepOver<CR>")
			vim.keymap.set("n", "<leader>hc", ":DapContinue<CR>")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}
