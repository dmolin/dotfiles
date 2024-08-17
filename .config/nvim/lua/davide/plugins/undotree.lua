return {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	config = function()
		local keymap = vim.keymap -- for conciseness

		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_SplitWidth = 55
		vim.g.undotree_DiffpanelHeight = 10

		keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle undotree" })
	end,
	lazy = true,
}
