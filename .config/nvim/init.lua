vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true -- vim.cmd("source $HOME/.config/nvim/vimscript/init.vim")

require("davide.core")
require("davide.lazy")
