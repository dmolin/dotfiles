vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- opt.relativenumber = false
opt.number = false

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case, assume you want case-sensitive
opt.inccommand = "split" -- show live preview of substitution

opt.cursorline = true

-- turn on termguicolors for tokionight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- undo file
opt.undofile = true -- save undo history to file

-- free buffers for hidden windows
opt.bufhidden = "unload"

vim.o.showtabline = 2
vim.g.maplocalleader = ","

-- disable caps lock while vim is running
-- vim.cmd("au VimEnter * silent !setxkbmap -option caps:none")
local api = vim.api

-- Disable caps lock while vim is running
--[[
api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	command = "!setxkbmap -option ctrl:nocaps",
})

api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	command = "!setxkbmap -option",
})
--]]
