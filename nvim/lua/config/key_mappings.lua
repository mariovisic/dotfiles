-- I use ctrl+c instead of escape, but ctrl+c doesn't trigger some events which
-- are needed for LSP, let's map ctrl+c to match escape to get this behaviour
vim.keymap.set({ "i", "n", "v" }, "<C-C>", "<esc>")

-- <leader>n opens nvim-tree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", {
  noremap = true,
})

-- <leader>f copies the current buffers relative file path
vim.keymap.set({ "i", "n", "v" }, "<leader>f", ':let @* = expand("%")<cr>')

-- <leader>r opens nvim-spectre for find/replace
vim.keymap.set({ "i", "n", "v" }, "<leader>r", "<cmd>Spectre<cr>")

-- Diagnostics Key mappings
-- g+l opens the diagnostic message in a floating window!
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

-- LSP key mappings
-- g+d navigates to the function definition!
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)

-- Map ctrl+n to open the autocomplete dialog, scroll if already open!
vim.keymap.set("i", "<C-n>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Cmd>=MiniCompletion.complete_twostage()<CR>"
end, { expr = true })

PluginKeyMappings = {
  mini = function()
    return {
      -- Comment out lines with \c + vector
      comment = "<leader>c",
      comment_visual = "<leader>c",
      comment_line = "<leader>cc",
    }
  end,

  -- Experiment using both leader + ctrl key mappings to figure
  -- out which I actually use before locking one in :)
  telescope = function(telescope_config, resume_function)
    vim.keymap.set("n", "<C-p>", telescope_config.find_files, {})
    vim.keymap.set("n", "<C-f>", telescope_config.live_grep, {})
    vim.keymap.set("n", "<C-b>", telescope_config.buffers, {})
    vim.keymap.set("n", "<C-h>", telescope_config.help_tags, {})
    vim.keymap.set("n", "<C-t>", resume_function, {})

    vim.keymap.set("n", "<leader>p", telescope_config.find_files, {})
    vim.keymap.set("n", "<leader>b", telescope_config.buffers, {})
    vim.keymap.set("n", "<leader>h", telescope_config.help_tags, {})
    vim.keymap.set("n", "<leader>t", resume_function, {})
  end,

  telescope_defaults = function()
    return {
      -- I don't use the esc key as it's far away (I use ctrl+c instead).
      -- So remap ctrl+c inside of telescope to exit insert mode. In
      -- normal mode ctrl+c closes telescope
      i = { ["<C-c>"] = { "<esc>", type = "command" } },
      n = { ["<C-c>"] = "close" },
    }
  end,
}
