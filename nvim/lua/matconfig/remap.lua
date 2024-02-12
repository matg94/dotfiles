
-- Explorer - disabled, replaced with NvimTree
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- NvimTree
vim.keymap.set("n", "<ALT-1>", vim.cmd.NvimTreeFocus)

-- Move Commands
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Ctrl D/U to keep cursor in place
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in middle while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "nzzzv")

-- Keep copied value when pasting
vim.keymap.set("x", "p", "\"_dP")

-- Joining VIM clipboard with System one
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- CtrlC remap to escape
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Navbudy 
vim.keymap.set("n", "<C-p>", vim.cmd.Navbuddy) 
vim.keymap.set("n", "bb", vim.cmd.Navbuddy)

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "fmt", vim.lsp.buf.format)
