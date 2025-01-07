-- Use tab for autocomplete!
vim.api.nvim_set_keymap("i", "<Tab>", "<C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-p>", { noremap = true, silent = true })

-- I use ctrl+c instead of escape, but ctrl+c doesn't trigger some events which
-- are needed for LSP, let's map ctrl+c to match escape to get this behaviour
vim.keymap.set({ "i", "n", "v" }, "<C-C>", "<esc>")

-- <leader>n opens nvim-tree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", {
  noremap = true,
})
