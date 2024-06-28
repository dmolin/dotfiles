vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- increment

-- window management
keymap.set("n", "<leader>sh", "<C-w>v", { desc = "Split window on the right" }) -- split window vertically
keymap.set("n", "<leader>sv", "<C-w>s", { desc = "Split window on the bottom" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal in size" }) -- make split windows equal in size
keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split

-- tab control
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<C-Pagedown>", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
keymap.set("n", "<C-Pageup>", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

-- splits navigation
-- keymap.set("n", "<A-Left>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate to the left split" })
-- keymap.set("n", "<A-Right>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate to the right split" })
-- keymap.set("n", "<A-Down>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate to the bottom split" })
-- keymap.set("n", "<A-Up>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate to the upper split" })
-- keymap.set("n", "<A-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Navigate to the previous split" })
keymap.set("n", "<A-Left>", "<cmd>vertical resize -5<cr>", { desc = "Shrink split horizontally" })
keymap.set("n", "<A-Right>", "<cmd>vertical resize +5<cr>", { desc = "Expand split horizontally" })
keymap.set("n", "<A-Down>", "<cmd>resize -5<cr>", { desc = "Shrink split vertically" })
keymap.set("n", "<A-Up>", "<cmd>resize +5<cr>", { desc = "Expand split vertically" })

-- moving around in a buffer
keymap.set("n", "<C-s>", ":+5<CR>", { desc = "Scroll down a few lines" })
keymap.set("n", "<C-a>", ":-5<CR>", { desc = "Scroll up a few lines" })

-- useful shortcuts
--
-- C-o -> go back to previous file
-- SPACE-ca -> Suggested code actions (useful with errors)
-- SPACE-rn -> smart rename of a variable or function in all its usages!
-- K -> documentation for what's under the cursor
-- while on the tree
-- a -> create new file or folder (folder ends with "/")
-- e -> rename file
-- d -> delete file
-- Shift + >> Indent line, also "=="
-- Shift + << Unindent line
--   this will also applye to multiple lines if you have a visual selection
--  ` -> see marks
