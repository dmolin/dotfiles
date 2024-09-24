function delete_unused_buffers()
	-- Get all buffers
	local buffers = vim.api.nvim_list_bufs()

	-- Get all windows across all tabs
	local windows = {}
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			table.insert(windows, win)
		end
	end

	-- Track which buffers are in use
	local used_buffers = {}
	for _, win in ipairs(windows) do
		used_buffers[vim.api.nvim_win_get_buf(win)] = true
	end

	-- Delete unused buffers
	local deleted = 0
	for _, buf in ipairs(buffers) do
		if
			not used_buffers[buf]
			and vim.api.nvim_buf_is_valid(buf)
			and vim.api.nvim_buf_get_option(buf, "buftype") ~= "terminal"
		then
			-- vim.print("Deleting buffer: " .. buf)
			vim.api.nvim_buf_delete(buf, { force = true })
			deleted = deleted + 1
		end
	end

	print(deleted, "unused buffers have been deleted.")
end

vim.api.nvim_create_user_command("DeleteUnusedBuffers", delete_unused_buffers, {})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = delete_unused_buffers,
})
