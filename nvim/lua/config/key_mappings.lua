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

-- <leader>f copies the current buffers relative file path
vim.keymap.set({ "i", "n", "v" }, "<leader>f", ':let @* = expand("%")<cr>')

PluginKeyMappings = {
  mini = function()
    return {
      -- Comment out lines with \c + vector
      comment = "<leader>c",
      comment_visual = "<leader>c",
      comment_line = "<leader>cc",
    }
  end,

  telescope = function(telescope_config, resume_function)
    vim.keymap.set("n", "<C-P>", telescope_config.find_files, {})
    vim.keymap.set("n", "<C-F>", telescope_config.live_grep, {})
    vim.keymap.set("n", "<leader>fb", telescope_config.buffers, {})
    vim.keymap.set("n", "<leader>fh", telescope_config.help_tags, {})
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

  lsp_formatting = function()
    -- format files with LSP using gq
    vim.keymap.set({ "n", "x" }, "gq", function()
      vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, {})
  end,
}
