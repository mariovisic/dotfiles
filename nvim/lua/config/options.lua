-- Syntax settings (2 space soft-tabs)
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Use the system clipboard when yanking/pasting
vim.api.nvim_set_option("clipboard", "unnamed")

-- Disable netrw as it interferes with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Color scheme
vim.o.termguicolors = true
